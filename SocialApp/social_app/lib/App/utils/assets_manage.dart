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
  }) {
    final isSvg = Uri.parse(path).path.toLowerCase().endsWith('.svg');

    if (isSvg && path.startsWith('assets/')) {
      return SvgPicture.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        placeholderBuilder:
            (_) => placeholder ?? _loadingIndicator(width, height),
      );
    }

    if (isSvg && path.startsWith('http')) {
      return SvgPicture.network(
        path,
        width: width,
        height: height,
        fit: fit,
        placeholderBuilder:
            (_) => placeholder ?? _loadingIndicator(width, height),
      );
    }

    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ Lỗi tải ảnh: $error');
          return _fallbackWidget();
        },
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? _loadingIndicator(width, height);
        },
      );
    }

    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _fallbackWidget(),
      );
    }

    return Image.file(
      File(path),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _fallbackWidget(),
    );
  }

  static Widget _fallbackWidget() {
    return const Icon(Icons.broken_image, size: 48, color: Colors.grey);
  }

  static Widget _loadingIndicator(double? width, double? height) {
    return SizedBox(
      width: width,
      height: height,
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
