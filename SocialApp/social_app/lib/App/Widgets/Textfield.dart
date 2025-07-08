import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller; // Thêm tham số controller

  const CustomInputField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.controller, // Thêm vào constructor
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  void _toggleObscure() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller, // Gán controller cho TextField
      obscureText: _obscure,
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: const Color(0xFFF3F5F7),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: _toggleObscure,
        )
            : null,
      ),
    );
  }
}