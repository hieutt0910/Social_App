import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


import 'App/Pages/Selection/category_screen.dart';
import 'App/Pages/auth/forgot_password.dart';
import 'App/Pages/auth/set_new_password_screen.dart';
import 'App/Pages/auth/signin_screen.dart';
import 'App/Pages/auth/signup_screen.dart';
import 'App/Pages/auth/verify_screen.dart';
import 'App/Pages/profile/edit_profile_page.dart';
import 'App/Pages/profile/other_profile_user.dart';
import 'App/Pages/profile/profile_screen.dart';
import 'App/Pages/profile/user_profile.dart';
import 'App/Pages/splash/splash_screen.dart';
import 'App/Pages/widget_tree.dart';
import 'Data/Repositories/dynamic_link_handler.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Khởi tạo Firebase
  await DynamicLinksHandler.initDynamicLinks(); // Khởi tạo Dynamic Links
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      navigatorKey: DynamicLinksHandler.navigatorKey, // Thêm navigatorKey cho Dynamic Links
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // Bắt đầu từ SplashScreen
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
        '/widget_tree': (context) => const WidgetTree(), // Thêm WidgetTree vào routes
      },
    );
  }
}