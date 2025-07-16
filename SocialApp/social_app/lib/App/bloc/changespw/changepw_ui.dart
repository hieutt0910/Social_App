import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Widgets/button.dart';
import '../../Widgets/text.dart';
import '../../Widgets/textfield.dart';
import 'changepw_state.dart';
import 'changepw_event.dart';
import 'changepw_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
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
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) async {
        if (state is ChangePasswordSuccess) {
          // Clear local data
          await FirebaseAuth.instance.signOut();
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();

          context.go('/sign-in');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully. Please sign in again')),
          );
        } else if (state is ChangePasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
          if (state.error.contains('Please sign in again')) {
            context.go('/sign-in');
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is ChangePasswordLoading;
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
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 30,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 40,
                    left: 0,
                    right: 0,
                    child: Center(
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
                                'Enter your old and new password',
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
                        FormLabel(text: 'Old Password'),
                        CustomInputField(
                          hintText: 'Old Password',
                          obscureText: true,
                          controller: _oldPasswordController,
                        ),
                        const SizedBox(height: 16),
                        FormLabel(text: 'New Password'),
                        CustomInputField(
                          hintText: 'New Password',
                          obscureText: true,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 16),
                        FormLabel(text: 'Confirm New Password'),
                        CustomInputField(
                          hintText: 'Confirm New Password',
                          obscureText: true,
                          controller: _confirmPasswordController,
                        ),
                        const SizedBox(height: 70),
                        CustomButton(
                          text: 'SAVE CHANGES',
                          onPressed: () {
                            context.read<ChangePasswordBloc>().add(
                              UpdatePasswordEvent(
                                oldPassword: _oldPasswordController.text.trim(),
                                newPassword: _passwordController.text.trim(),
                                confirmPassword: _confirmPasswordController.text.trim(),
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