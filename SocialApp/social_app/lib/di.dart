import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
}
