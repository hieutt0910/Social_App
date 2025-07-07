import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Repository/dynamic_links_handler.dart';
import '../Reuse/Button.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loadOtp() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final otp = prefs.getString('pending_otp') ?? '';
      print('Loaded OTP from SharedPreferences: $otp'); // Debug
      if (otp.isNotEmpty) {
        setState(() {
          _otpController.text = otp;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No OTP found. Please check your email.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading OTP: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyOTP(String email) async {
    if (_isLoading) return;
    if (_otpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedOtp = prefs.getString('pending_otp') ?? '';
      final enteredOtp = _otpController.text.trim();

      print('Verifying OTP - Stored: $storedOtp, Entered: $enteredOtp');
      if (enteredOtp == storedOtp) {
        await FirebaseAuth.instance.currentUser?.reload();
        if (FirebaseAuth.instance.currentUser != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification successful')),
          );
          Navigator.pushReplacementNamed(context, '/category');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not authenticated, please try again')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resendLink(String email) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {
      String otp = generateOtp();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pending_otp', otp);
      await prefs.setString('pending_email', email);

      await DynamicLinksHandler.sendSignInLink(email, customParams: {'otp': otp});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification code $otp resent to your email.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error resending link: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String generateOtp() {
    return (100000 + Random().nextInt(900000)).toString();
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadOtp, // Kéo xuống để làm mới
        child: Column(
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
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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
                              'A message with verification code\nwas sent to your email.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF242424),
                                fontSize: 18,
                                height: 1.6,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        textAlign: TextAlign.center,
                        controller: _otpController,
                        decoration: const InputDecoration(
                          hintText: 'Type verification code',
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
                      GestureDetector(
                        onTap: () async {
                          await _resendLink(email);
                        },
                        child: const Text(
                          "DON'T RECEIVE THE CODE",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF242424),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        text: 'VERIFY',
                        onPressed: () => _verifyOTP(email),
                        isLoading: _isLoading,
                      ),
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
      ),
    );
  }
}