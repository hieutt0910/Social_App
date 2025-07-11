import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/app/pages/search_topic.dart';
import 'App/Pages/profile/collection_page.dart';
import 'Data/model/collection.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DynamicLinksHandler.initDynamicLinks(context); // Khởi tạo Dynamic Links với context
    });
  }

  // Cấu hình GoRouter
  static final GoRouter _router = GoRouter(
    navigatorKey: DynamicLinksHandler.navigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/boarding',
        builder: (context, state) => const BoardingPage(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/verify',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return VerifyPage(
            email: args?['email'] ?? '',
            fromRoute: args?['fromRoute'] ?? 'sign_in',
          );
        },
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/set-new-password',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return SetNewPasswordPage(email: args?['email'] ?? '');
        },
      ),
      GoRoute(
        path: '/category',
        builder: (context, state) => const ChooseRolePage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const AccountPage(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/user-profile',
        builder: (context, state) => const UserProfilePage(),
      ),
      GoRoute(
        path: '/other-profile',
        builder: (context, state) => const OtherUserProfilePage(),
      ),
      GoRoute(
        path: '/collection-detail',
        builder: (context, state) {
          final collection = state.extra as Collection?;
          return CollectionDetailPage(collection: collection ?? Collection(title: '', coverImage: '', images: []));
        },
      ),
      GoRoute(
        path: '/widget-tree',
        builder: (context, state) => const WidgetTree(),
      ),
      GoRoute(
        path: '/search-topic',
        builder: (context, state) => const SearchTopic(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}