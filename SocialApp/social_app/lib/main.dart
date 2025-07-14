import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/app/routes/app_routes.dart';
import 'package:social_app/di.dart'; 
import 'package:social_app/data/repositories/dynamic_link_handler.dart';
import 'package:social_app/app/bloc/post/post_bloc.dart';

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
      DynamicLinksHandler.initDynamicLinks(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostBloc>(
      create: (_) => sl<PostBloc>(), 
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
