import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/app/bloc/forgotpassword/forgotpw_bloc.dart';
import 'package:social_app/app/bloc/setnewpw/setnewpw_bloc.dart';
import 'package:social_app/app/bloc/signin/signin_bloc.dart';
import 'package:social_app/app/bloc/signup/signup_bloc.dart';
import 'package:social_app/app/bloc/verify/verify_bloc.dart';
import 'package:social_app/data/datasources/firebase/post_remote_data_source_impl.dart';

import 'package:social_app/data/datasources/post_remote_data_source.dart';
import 'package:social_app/data/repositories/post_repository_iplm.dart';
import 'package:social_app/data/servives/cloudinary_service.dart';
import 'package:social_app/domain/repositories/post_repository.dart';

import 'package:social_app/domain/usecase/post/create_post.dart';
import 'package:social_app/domain/usecase/post/get_post.dart';
import 'package:social_app/domain/usecase/post/toggle_like_post.dart';

import 'package:social_app/app/bloc/post/post_bloc.dart';


final sl = GetIt.instance;

Future<void> initDI() async {
  // Đăng ký CloudinaryService
  sl.registerLazySingleton<CloudinaryService>(() => CloudinaryService());

  // Đăng ký PostRemoteDataSourceImpl với CloudinaryService
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
      cloudinaryService: sl(),
    ),
  );

  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => CreatePostUseCase(sl()));
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));
  sl.registerLazySingleton(() => ToggleLikeUseCase(sl()));

  sl.registerFactory(() => PostBloc(
        createPost: sl(),
        getPosts: sl(),
        toggleLike: sl(),
      ));
  // Đăng ký các BLoC cho Authentication
  sl.registerFactory(() => SignInBloc());
  sl.registerFactory(() => SignUpBloc());
  sl.registerFactory(() => ForgotPasswordBloc());

  // Đăng ký VerifyBloc với tham số email và fromRoute
  sl.registerFactoryParam<VerifyBloc, String, String>(
        (email, fromRoute) => VerifyBloc(
      email: email ?? '',
      fromRoute: fromRoute ?? '',
    ),
  );

  // Đăng ký SetNewPasswordBloc với tham số email
  sl.registerFactoryParam<SetNewPasswordBloc, String, void>(
        (email, _) => SetNewPasswordBloc(email: email ?? ''),
  );
}
