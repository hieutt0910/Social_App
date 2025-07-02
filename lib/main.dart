import 'package:final_project/profile/edit_profile_page.dart';
import 'package:final_project/profile/other_profile_user.dart';
import 'package:final_project/profile/profile_screen.dart';
import 'package:final_project/profile/user_profile.dart';
import 'package:final_project/splash/splash_screen.dart';
import 'package:flutter/material.dart';

import 'Category/category_screen.dart';
import 'auth/forgot_password.dart';
import 'auth/set_new_password_screen.dart';
import 'auth/signin_screen.dart';
import 'auth/signup_screen.dart';
import 'auth/verify_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/boarding': (context) => const BoardingPage(),
        '/sign in': (context) => const SignInPage(),
        '/sign up': (context) => const SignUpPage(),
        '/verify': (context) => const VerifyPage(),
        '/forgot password': (context) => const ForgotPasswordPage(),
        '/set new password': (context) => const SetNewPasswordPage(),
        '/category': (context) => const ChooseRolePage(),
        '/profile': (context) => const AccountPage(),
        '/edit profile': (context) => const EditProfilePage(),
        '/user profile': (context) => const UserProfilePage(),
        '/other profile': (context) => const OtherUserProfilePage(),
      },
    );
  }
}

