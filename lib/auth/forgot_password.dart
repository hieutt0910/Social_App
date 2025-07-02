import 'package:flutter/material.dart';
import '../Reuse/Button.dart';
import '../Reuse/TextField.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // Ảnh nền
          Stack(
            children: [
              ClipRRect(
                child: Image.asset(
                  'assets/images/welcome1.png',
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.32,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Nội dung form bên dưới
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  left: 24,
                  right: 24,
                  top: 30,
                ),
                child: Column(
                  children: [
                    // Tiêu đề
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          colors: [Color(0xFF888BF4), Color(0xFF5151C6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        );
                      },
                      child: const Text(
                        'TYPE YOUR EMAIL',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Thông báo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F2FD),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'We will send you instruction on\nhow to reset your password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF242424),
                              fontSize: 16,
                              height: 1.6,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Ô nhập email
                    const CustomInputField(
                      hintText: 'Email',
                    ),

                    const SizedBox(height: 30),

                    // Nút gửi
                    CustomButton(
                      text: 'SEND',
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/set new password');
                      },
                    ),

                    const SizedBox(height: 40),

                    // Image6 dưới cùng
                    Image.asset(
                      'assets/images/img_1.png',
                      width: 280,
                      height: 280,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
