import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Data/Repositories/dynamic_link_handler.dart';
import '../../Widgets/Button.dart';

class VerifyPage extends StatefulWidget {
  final String email;
  final String fromRoute;

  const VerifyPage({super.key, required this.email, required this.fromRoute});

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  StreamSubscription<void>? _linkHandledSubscription;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _linkHandledSubscription = DynamicLinksHandler.onLinkHandled.listen((_) {
      if (mounted) {
        _loadOtp();
      }
    });

    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        _loadOtp();
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _linkHandledSubscription?.cancel();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadOtp() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final otp = prefs.getString('pending_otp') ?? '';
      print('Loaded OTP from SharedPreferences: $otp');
      if (otp.isNotEmpty) {
        setState(() {
          _otpController.text = otp;
        });
        _refreshTimer?.cancel();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy OTP. Vui lòng kiểm tra email của bạn.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải OTP: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyOTP() async {
    if (_isLoading) return;
    if (_otpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập OTP')),
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
        if (widget.fromRoute != 'forgot_password') {
          await FirebaseAuth.instance.currentUser?.reload();
          if (FirebaseAuth.instance.currentUser == null) {
            final String? storedPassword = prefs.getString('temp_password');
            if (storedPassword != null && storedPassword.isNotEmpty) {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: widget.email,
                password: storedPassword,
              );
              await FirebaseAuth.instance.currentUser?.reload();
            }
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xác thực thành công')),
        );


        if (widget.fromRoute == 'forgot_password') {
          context.go('/set-new-password', extra: {'email': widget.email});
        } else {
          if (FirebaseAuth.instance.currentUser != null) {
            context.go('/category');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Người dùng chưa được xác thực, vui lòng thử lại')),
            );
            context.go('/sign-in');
            return;
          }
        }

        await prefs.remove('pending_otp');
        await prefs.remove('pending_email');
        await prefs.remove('temp_password');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP không hợp lệ')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xác thực OTP: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resendLink() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await DynamicLinksHandler.sendSignInLink(widget.email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Liên kết xác thực với OTP đã được gửi lại đến email của bạn.')),
      );
      _refreshTimer?.cancel();
      _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
        if (mounted) {
          _loadOtp();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi gửi lại liên kết: $e')),
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
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadOtp,
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
                        onTap: _resendLink,
                        child: const Text(
                          "DON'T RECEIVE THE CODE?",
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
                        onPressed: _verifyOTP,
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