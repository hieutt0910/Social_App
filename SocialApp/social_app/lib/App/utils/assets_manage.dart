import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetsManager {
  static Widget showImage(
    String path, {
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    Widget? placeholder,
    bool isCircle = false,
  }) {
    final isSvg = Uri.parse(path).path.toLowerCase().endsWith('.svg');

    Widget wrap(Widget img) => isCircle ? ClipOval(child: img) : img;

    if (isSvg && path.startsWith('assets/')) {
      return wrap(
        SvgPicture.asset(
          path,
          width: width,
          height: height,
          fit: fit,
          placeholderBuilder:
              (_) => placeholder ?? _loadingIndicator(width, height),
        ),
      );
    }

    if (isSvg && path.startsWith('http')) {
      return wrap(
        SvgPicture.network(
          path,
          width: width,
          height: height,
          fit: fit,
          placeholderBuilder:
              (_) => placeholder ?? _loadingIndicator(width, height),
        ),
      );
    }

    if (path.startsWith('http')) {
      return wrap(
        Image.network(
          path,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, error, __) {
            return _fallbackWidget();
          },
          loadingBuilder: (_, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return placeholder ?? _loadingIndicator(width, height);
          },
        ),
      );
    }

    if (path.startsWith('assets/')) {
      return wrap(
        Image.asset(
          path,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => _fallbackWidget(),
        ),
      );
    }

    return wrap(
      Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _fallbackWidget(),
      ),
    );
  }

  static Widget _fallbackWidget() =>
      const Icon(Icons.broken_image, size: 48, color: Colors.grey);

  static Widget _loadingIndicator(double? width, double? height) {
    return SizedBox(
      width: width,
      height: height,
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
