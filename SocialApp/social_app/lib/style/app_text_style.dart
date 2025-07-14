// lib/app/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/style/app_color.dart'; // Nếu bạn dùng Google Fonts

class AppTextStyles {
  static final TextStyle bodyBold = GoogleFonts.manrope(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static final TextStyle bodyTextGrey = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.customGrey,
  );
  static final TextStyle bodyTextMediumbGrey = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.customGrey,
  );
  static final TextStyle bodyTextBlack = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  static final TextStyle bodyTextMediumblack = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static final TextStyle number = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.customGrey,
  );
}
