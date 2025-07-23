import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../Widgets/button.dart';
import '../../Widgets/textfield.dart';
import '../../bloc/signin/signin_bloc.dart';
import '../../bloc/signin/signin_event.dart';
import '../../bloc/signin/signin_state.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          final Map<String, dynamic>? args = GoRouterState.of(context).extra as Map<String, dynamic>?;
          final String fromRoute = args?['fromRoute'] ?? '';
          if (fromRoute == 'set_new_password') {
            context.go('/set-new-password', extra: {'email': _emailController.text.trim()});
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Verification link with OTP sent to your email. Please check your inbox.')),
            );
          }
        } else if (state is SignInFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is SignInLoading;
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
                          onPressed: () {
                            context.read<SignInBloc>().add(
                              SignInWithEmailEvent(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              ),
                            );
                          },
                          isLoading: isLoading,
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
                                  context.read<SignInBloc>().add(SignInWithGoogleEvent());
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
                          child: Text.rich(
                            TextSpan(
                              text: "Don't have account? ",
                              style: const TextStyle(color: Colors.black, fontSize: 18),
                              children: [
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () => context.go('/sign-up'),
                                    child: Text(
                                      'SIGN UP',
                                      style: TextStyle(
                                        color: Colors.deepPurple.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
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
      },
    );
  }
}