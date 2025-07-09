
import 'package:go_router/go_router.dart';
import 'package:social_app/app/pages/Selection/category_screen.dart';
import 'package:social_app/app/pages/auth/forgot_password.dart';
import 'package:social_app/app/pages/auth/set_new_password_screen.dart';
import 'package:social_app/app/pages/auth/signin_screen.dart';
import 'package:social_app/app/pages/auth/signup_screen.dart';
import 'package:social_app/app/pages/auth/verify_screen.dart';
import 'package:social_app/app/pages/profile/edit_profile_page.dart';
import 'package:social_app/app/pages/profile/other_profile_user.dart';
import 'package:social_app/app/pages/profile/profile_screen.dart';
import 'package:social_app/app/pages/profile/user_profile.dart';
import 'package:social_app/app/pages/search_topic.dart';
import 'package:social_app/app/pages/splash/splash_screen.dart';
import 'package:social_app/app/pages/widget_tree.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/boarding', builder: (context, state) => const BoardingPage()),
      GoRoute(path: '/sign-in', builder: (context, state) => const SignInPage()),
      GoRoute(path: '/sign-up', builder: (context, state) => const SignUpPage()),
      GoRoute(path: '/verify', builder: (context, state) => const VerifyPage()),
      GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordPage()),
      GoRoute(path: '/set-new-password', builder: (context, state) => const SetNewPasswordPage()),
      GoRoute(path: '/category', builder: (context, state) => const ChooseRolePage()),
      GoRoute(path: '/profile', builder: (context, state) => const AccountPage()),
      GoRoute(path: '/edit-profile', builder: (context, state) => const EditProfilePage()),
      GoRoute(path: '/user-profile', builder: (context, state) => const UserProfilePage()),
      GoRoute(path: '/other-profile', builder: (context, state) => const OtherUserProfilePage()),
      GoRoute(path: '/widget-tree', builder: (context, state) => const WidgetTree()),
      GoRoute(path: '/searchTopic', builder: (context, state) => const SearchTopic()),
    ],
  );
}
