// lib/App/Widgets/gradient_text.dart
import 'package:flutter/material.dart';
import 'package:social_app/style/app_color.dart';

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextStyle? style;
  final Gradient gradient;

  const GradientText({
    super.key,
    required this.text,
    this.style,
    this.gradient = const LinearGradient(
      colors: [AppColors.startGradient, AppColors.endGradient],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
        text,
        style:
            style?.copyWith(color: Colors.white) ??
            TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
      ),
    );
  }
}
