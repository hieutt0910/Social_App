import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Data/Repositories/dynamic_link_handler.dart';
import '../../Widgets/Button.dart';
import '../../Widgets/Textfield.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  String generateOtp() {
    return (100000 + Random().nextInt(900000)).toString(); // Tạo mã OTP 6 chữ số
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_isLoading) return;
    try {
      if (!_emailController.text.trim().contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid email address')),
        );
        return;
      }

      if (_passwordController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your password')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        String otp = generateOtp();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pending_otp', otp);
        await prefs.setString('pending_email', _emailController.text.trim());

        await DynamicLinksHandler.sendSignInLink(
          _emailController.text.trim(),
          customParams: {'otp': otp},
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification code sent to your email. Please check your inbox.')),
        );

        Navigator.pushNamed(
          context,
          '/verify',
          arguments: _emailController.text.trim(),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                    CustomInputField(
                      hintText: 'Email',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 16),
                    CustomInputField(
                      hintText: 'Password',
                      obscureText: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/forgot password');
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'FORGOT PASSWORD',
                            style: TextStyle(
                              color: Color(0xFF5252C7),
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'LOG IN',
                      onPressed: _signIn,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 48),
                    const Center(
                      child: Text(
                        'OR LOG IN BY',
                        style: TextStyle(
                          fontSize: 18,
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
                          style: const TextStyle(color: Colors.black, fontSize: 18),
                          children: [
                            TextSpan(
                              text: ' SIGN UP',
                              style: TextStyle(
                                color: Colors.deepPurple.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
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