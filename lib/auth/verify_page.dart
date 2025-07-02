import 'package:flutter/material.dart';
import '../Reuse/Button.dart';
import '../Reuse/TextField.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
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

          // Nội dung xác thực
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
                        'VERIFICATION',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4), // nhỏ hơn TextField padding một chút
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 18), // bỏ horizontal
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F2FD),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center( // để căn giữa text
                          child: Text(
                            'A message with verification code\nwas sent to your email.',
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

                    // Input mã xác thực
                    const TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Enter verification code',
                        filled: true,
                        fillColor: Color(0xFFF3F5F7),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      "DON'T RECEIVE THE CODE",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF242424),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Nút xác thực
                    CustomButton(
                      text: 'VERIFY',
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/category');
                      },
                    ),

                    const SizedBox(height: 20),

                    // Image6 ở cuối
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
