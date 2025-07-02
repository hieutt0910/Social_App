import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../Reuse/Button.dart';
import '../Reuse/TextField.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // Ảnh nền + bo góc + nền trắng đè
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

          // Form Đăng Ký
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomInputField(hintText: 'Email'),
                    const SizedBox(height: 16),
                    const CustomInputField(
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    const CustomInputField(
                      hintText: 'Confirm Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'SIGN UP',
                      onPressed: () {
                        // Xử lý đăng ký
                      },
                    ),
                    const SizedBox(height: 30),
                    const SizedBox(height: 24),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have account?',
                          style: const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: ' SIGN UP',
                              style: TextStyle(
                                color: Colors.deepPurple.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                Navigator.pushReplacementNamed(context, '/sign in');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
