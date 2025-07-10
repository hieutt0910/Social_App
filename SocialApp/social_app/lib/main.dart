import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_app/app/pages/search_topic.dart';


import 'app/pages/Selection/category_screen.dart';
import 'app/pages/auth/forgot_password.dart';
import 'app/pages/auth/set_new_password_screen.dart';
import 'app/pages/auth/signin_screen.dart';
import 'app/pages/auth/signup_screen.dart';
import 'app/pages/auth/verify_screen.dart';
import 'app/pages/profile/edit_profile_page.dart';
import 'app/pages/profile/other_profile_user.dart';
import 'app/pages/profile/profile_screen.dart';
import 'app/pages/profile/user_profile.dart';
import 'app/pages/splash/splash_screen.dart';
import 'app/pages/widget_tree.dart';
import 'data/repositories/dynamic_link_handler.dart';

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
      navigatorKey: DynamicLinksHandler.navigatorKey,
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
        '/widget_tree': (context) => const WidgetTree(),
        '/search topic': (context) => SearchTopic(),
      },
    );
  }
}