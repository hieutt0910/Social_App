// lib/App/Widgets/gradient_text.dart
import 'package:flutter/material.dart';

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
      colors: [Color(0xFF5151C6), Color(0xFF888BF4)],
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
