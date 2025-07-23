import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/app/bloc/account/account_bloc.dart';
import 'package:social_app/app/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:social_app/app/bloc/forgotpassword/forgotpw_bloc.dart';
import 'package:social_app/app/bloc/signin/signin_bloc.dart';
import 'package:social_app/app/bloc/signup/signup_bloc.dart';
import 'package:social_app/app/bloc/post/post_bloc.dart';
import 'package:social_app/app/bloc/user_profile/user_profile_bloc.dart';
import 'package:social_app/app/routes/app_routes.dart';
import 'package:social_app/di.dart';
import 'package:social_app/data/repositories/dynamic_link_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initDI();
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
      DynamicLinksHandler.initDynamicLinks(AppRouter.router);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignInBloc>(create: (_) => sl<SignInBloc>()),
        BlocProvider<SignUpBloc>(create: (_) => sl<SignUpBloc>()),
        BlocProvider<ForgotPasswordBloc>(
          create: (_) => sl<ForgotPasswordBloc>(),
        ),
        BlocProvider<PostBloc>(create: (_) => sl<PostBloc>()),
        BlocProvider<AccountBloc>(create: (_) => sl<AccountBloc>()),
        BlocProvider<UserProfileBloc>(create: (_) => sl<UserProfileBloc>()),
        BlocProvider<EditProfileBloc>(create: (_) => sl<EditProfileBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
