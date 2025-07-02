import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../Reuse/Button.dart';
import '../Reuse/TextField.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
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
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
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
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/forgot password');
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'FORGOT PASSWORD',
                            style: TextStyle(
                              color: Color(0xFF5252C7),
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'LOG IN',
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/verify');
                      },
                    ),
                    const SizedBox(height: 48),
                    const Center(
                      child: Text(
                        'OR LOG IN BY',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF606060),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE3E4FC),
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              print('Image tapped!');
                            },
                            child: Image.asset(
                              'assets/images/img.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),

                      ),
                    ),
                    const SizedBox(height: 48),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have account?',
                          style: const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: ' SIGN UP',
                              style: TextStyle(
                                color: Colors.deepPurple.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                Navigator.pushReplacementNamed(context, '/sign up');
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
