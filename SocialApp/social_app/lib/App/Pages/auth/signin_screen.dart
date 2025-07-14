import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Data/Repositories/dynamic_link_handler.dart';
import '../../../Data/model/user.dart';
import '../../Widgets/button.dart';
import '../../Widgets/textfield.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map<String, dynamic>? args = GoRouterState.of(context).extra as Map<String, dynamic>?;
      if (args != null && args['email'] != null) {
        _emailController.text = args['email'];
      }
    });
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
          const SnackBar(content: Text('Vui lòng nhập địa chỉ email hợp lệ')),
        );
        return;
      }

      if (_passwordController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập mật khẩu')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pending_email', _emailController.text.trim());
      await prefs.setString('temp_password', _passwordController.text.trim());

      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Lưu thông tin người dùng vào Firestore
      if (userCredential.user != null) {
        final appUser = AppUser(
          uid: userCredential.user!.uid,
          email: _emailController.text.trim(),
        );
        await appUser.saveToFirestore();
      }

      final Map<String, dynamic>? args = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final String fromRoute = args?['fromRoute'] ?? '';

      if (fromRoute == 'set_new_password') {
        context.go('/set-new-password', extra: {'email': _emailController.text.trim()});
      } else {
        await DynamicLinksHandler.sendSignInLink(_emailController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Liên kết xác thực với OTP đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư đến.')),
        );
        context.go('/verify', extra: {'email': _emailController.text.trim(), 'fromRoute': 'sign_in'});
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Không tìm thấy người dùng với email này.';
          break;
        case 'wrong-password':
          errorMessage = 'Mật khẩu không đúng.';
          break;
        default:
          errorMessage = 'Lỗi: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập bằng Google đã bị hủy')),
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Lưu thông tin người dùng vào Firestore
        final appUser = AppUser(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? 'Unknown',
          imageUrl: user.photoURL,
        );
        await appUser.saveToFirestore();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pending_email', user.email ?? '');

        await DynamicLinksHandler.sendSignInLink(user.email ?? '');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Liên kết xác thực với OTP đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư đến.')),
        );

        context.go('/verify', extra: {'email': user.email ?? '', 'fromRoute': 'sign_in'});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập bằng Google thất bại')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi đăng nhập bằng Google: $e')),
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
                        context.go('/forgot-password');
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'FORGOT PASSWORD?',
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
                            onTap: _signInWithGoogle,
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
                                  context.go('/sign-up');
                                },
                            ),
                          ],
                        ),
                      ),
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