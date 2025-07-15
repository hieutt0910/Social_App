import 'package:go_router/go_router.dart';
import 'package:social_app/Data/model/collection.dart';
import 'package:social_app/app/pages/Selection/category_screen.dart';
import 'package:social_app/app/pages/auth/forgot_password.dart';
import 'package:social_app/app/pages/auth/set_new_password_screen.dart';
import 'package:social_app/app/pages/auth/signin_screen.dart';
import 'package:social_app/app/pages/auth/signup_screen.dart';
import 'package:social_app/app/pages/auth/verify_screen.dart';
import 'package:social_app/app/pages/post/create_post_page.dart';
import 'package:social_app/app/pages/post/view_detail_post_page.dart';
import 'package:social_app/app/pages/profile/collection_page.dart';
import 'package:social_app/app/pages/profile/edit_profile_page.dart';
import 'package:social_app/app/pages/profile/other_profile_user.dart';
import 'package:social_app/app/pages/profile/profile_screen.dart';
import 'package:social_app/app/pages/profile/user_profile.dart';
import 'package:social_app/app/pages/search_topic.dart';
import 'package:social_app/app/pages/splash/splash_screen.dart';
import 'package:social_app/app/pages/widget_tree.dart';
import 'package:social_app/data/repositories/dynamic_link_handler.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: DynamicLinksHandler.navigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/boarding', builder: (_, __) => const BoardingPage()),
      GoRoute(path: '/sign-in', builder: (_, __) => const SignInPage()),
      GoRoute(path: '/sign-up', builder: (_, __) => const SignUpPage()),
      GoRoute(
        path: '/verify',
        builder: (_, state) {
          final args = state.extra as Map<String, dynamic>?;

          return VerifyPage(
            email: args?['email'] ?? '',
            fromRoute: args?['fromRoute'] ?? 'sign_in',
          );
        },
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (_, __) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/set-new-password',
        builder: (_, state) {
          final args = state.extra as Map<String, dynamic>?;

          return SetNewPasswordPage(email: args?['email'] ?? '');
        },
      ),
      GoRoute(path: '/category', builder: (_, __) => const ChooseRolePage()),
      GoRoute(path: '/profile', builder: (_, __) => const AccountPage()),
      GoRoute(
        path: '/edit-profile',
        builder: (_, __) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/user-profile',
        builder: (_, __) => const UserProfilePage(),
      ),
      GoRoute(
        path: '/other-profile',
        builder: (_, __) => const OtherUserProfilePage(),
      ),
      GoRoute(
        path: '/collection-detail',
        builder: (_, state) {
          final collection = state.extra as Collection?;

          return CollectionDetailPage(
            collection:
                collection ?? Collection(title: '', coverImage: '', images: []),
          );
        },
      ),
      GoRoute(path: '/widget-tree', builder: (_, __) => const WidgetTree()),
      GoRoute(path: '/search-topic', builder: (_, __) => const SearchTopic()),
      GoRoute(path: '/create-post', builder: (_, __) => const CreatePostPage()),
      GoRoute(
        path: '/view-post',
        builder: (_, state) {
          final id = state.extra as String;
          return ViewDetailPostPage(postId: id);
        },
      ),
    ],
  );
}
