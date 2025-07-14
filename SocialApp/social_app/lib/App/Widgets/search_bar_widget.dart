import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode; // THÊM DÒNG NÀY

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.hintText = 'Search',
    this.onChanged,
    this.focusNode, // THÊM DÒNG NÀY
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode, // TRUYỀN VÀO ĐÂY
        onChanged: onChanged,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFFBDBDBD),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              width: 20,
              height: 20,
              colorFilter:
                  const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
