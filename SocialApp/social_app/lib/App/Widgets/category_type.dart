import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/app/widgets/gradient_text.dart'; // nếu bạn tự tạo GradientText

class CategoryType extends StatelessWidget {
  const CategoryType({super.key, required this.nameCategory});
  final String nameCategory;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nameCategory,
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/search-topic'),
            child: GradientText(text: 'View more', fontSize: 14),
          ),
        ],
      ),
    );
  }
}
