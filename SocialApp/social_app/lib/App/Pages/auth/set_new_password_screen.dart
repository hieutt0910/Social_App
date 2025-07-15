import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../Widgets/button.dart';
import '../../Widgets/textfield.dart';
import '../../bloc/setnewpw/setnewpw_bloc.dart';
import '../../bloc/setnewpw/setnewpw_event.dart';
import '../../bloc/setnewpw/setnewpw_state.dart';


class SetNewPasswordPage extends StatefulWidget {
  final String email;

  const SetNewPasswordPage({super.key, required this.email});

  @override
  _SetNewPasswordPageState createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetNewPasswordBloc, SetNewPasswordState>(
      listener: (context, state) {
        if (state is SetNewPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully')),
          );
          context.go('/sign-in');
        } else if (state is SetNewPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
          if (state.error.contains('Please re-sign in')) {
            context.go('/sign-in', extra: {'email': widget.email, 'fromRoute': 'set_new_password'});
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is SetNewPasswordLoading;
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
                        Center(
                          child: ShaderMask(
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
                              'SET NEW PASSWORD',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                fontSize: 18,
                              ),
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
                                'Enter your old password and new password',
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
                        CustomInputField(
                          hintText: 'Old Password',
                          obscureText: true,
                          controller: _oldPasswordController,
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          hintText: 'New Password',
                          obscureText: true,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          hintText: 'Confirm New Password',
                          obscureText: true,
                          controller: _confirmPasswordController,
                        ),
                        const SizedBox(height: 70),
                        CustomButton(
                          text: 'SEND',
                          onPressed: () {
                            context.read<SetNewPasswordBloc>().add(
                              UpdatePasswordEvent(
                                _oldPasswordController.text.trim(),
                                _passwordController.text.trim(),
                                _confirmPasswordController.text.trim(),
                              ),
                            );
                          },
                          isLoading: isLoading,
                        ),
                        Center(
                          child: Image.asset(
                            'assets/images/img_1.png',
                            width: 280,
                            height: 280,
                            fit: BoxFit.contain,
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