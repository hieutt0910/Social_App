import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../Widgets/button.dart';
import '../../Widgets/textfield.dart';
import '../../bloc/signup/signup_bloc.dart';
import '../../bloc/signup/signup_event.dart';
import '../../bloc/signup/signup_state.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification link with OTP sent to your email. Please check your inbox.')),
          );
          context.go('/verify', extra: {'email': _emailController.text.trim(), 'fromRoute': 'sign_up'});
        } else if (state is SignUpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is SignUpLoading;
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
                        const SizedBox(height: 16),
                        CustomInputField(
                          hintText: 'Confirm Password',
                          obscureText: true,
                          controller: _confirmPasswordController,
                        ),
                        const SizedBox(height: 40),
                        CustomButton(
                          text: 'SIGN UP',
                          onPressed: () {
                            context.read<SignUpBloc>().add(
                              SignUpWithEmailEvent(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                _confirmPasswordController.text.trim(),
                              ),
                            );
                          },
                          isLoading: isLoading,
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: 'Already have account? ',
                              style: const TextStyle(color: Colors.black, fontSize: 18),
                              children: [
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () => context.go('/sign-in'),
                                    child: Text(
                                      'SIGN IN',
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
                        const SizedBox(height: 20),
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