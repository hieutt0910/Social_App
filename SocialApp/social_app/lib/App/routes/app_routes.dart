import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/Data/model/collection.dart';
import 'package:social_app/app/bloc/setnewpw/setnewpw_bloc.dart';
import 'package:social_app/app/bloc/verify/verify_bloc.dart';
import 'package:social_app/app/pages/post/edit_post_page.dart';
import 'package:social_app/app/pages/selection/category_screen.dart';
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
import 'package:social_app/app/pages/search_post/hashtag_post.dart';
import 'package:social_app/app/pages/search_post/search_topic.dart';
import 'package:social_app/app/pages/splash/splash_screen.dart';
import 'package:social_app/app/pages/widget_tree.dart';
import 'package:social_app/data/repositories/dynamic_link_handler.dart';
import 'package:social_app/di.dart';
import 'package:social_app/domain/entity/post.dart';

import '../bloc/changespw/changepw_bloc.dart';
import '../bloc/changespw/changepw_ui.dart';

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
          final email = args?['email'] as String? ?? '';
          final fromRoute = args?['fromRoute'] as String? ?? 'sign_in';
          return BlocProvider(
            create: (_) => sl<VerifyBloc>(param1: email, param2: fromRoute),
            child: VerifyPage(email: email, fromRoute: fromRoute),
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
          final email = args?['email'] as String? ?? '';
          return BlocProvider(
            create: (_) => sl<SetNewPasswordBloc>(param1: email),
            child: SetNewPasswordPage(email: email),
          );
        },
      ),
      GoRoute(
        path: '/change-password',
        builder: (_, __) {
          return BlocProvider(
            create: (_) => sl<ChangePasswordBloc>(),
            child: const ChangePasswordPage(),
          );
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
        builder: (context, state) {
          final user = state.extra as AppUser;
          return OtherUserProfilePage(user: user);
        },
      ),
      GoRoute(
        path: '/collection-detail',
        builder: (_, state) {
          final args = state.extra as Map<String, dynamic>?;
          final collection = args?['collection'] as Collection?;
          return CollectionDetailPage(
            collection: collection ??
                Collection(
                  id: '',
                  title: 'Untitled',
                  coverImage: '',
                  imageIds: [],
                  ownerId: '',
                ),
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
      GoRoute(
        path: '/edit-post',
        builder: (context, state) {
          final post = state.extra as PostEntity;
          return EditPostPage(post: post);
        },
      ),

      GoRoute(
        path: '/hashtag-posts',
        builder: (_, state) {
          final tag = (state.extra as String).replaceFirst('#', '');
          return HashtagPostsPage(hashtag: tag);
        },
      ),
    ],
  );
}
