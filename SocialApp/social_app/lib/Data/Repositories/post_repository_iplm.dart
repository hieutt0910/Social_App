import 'dart:io';

import 'package:social_app/data/datasources/post_remote_data_source.dart';
import 'package:social_app/domain/entity/post.dart';
import 'package:social_app/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;

  PostRepositoryImpl(this.remote);

  @override
  Future<List<String>> uploadImages(String postId, List<File> images) =>
      remote.uploadImages(postId, images);

  @override
  Future<void> createPost(PostEntity post) => remote.createPost(post);

  @override
  Stream<List<PostEntity>> getPosts() => remote.getPosts();

  @override
  Future<void> deletePost(String postId) => remote.deletePost(postId);

  @override
  Future<void> likePost(String postId, String uid) =>
      remote.likePost(postId, uid);

  @override
  Future<void> unlikePost(String postId, String uid) =>
      remote.unlikePost(postId, uid);

  @override
  Future<void> incrementViews(String postId) => remote.incrementViews(postId);
  
  @override
  Stream<List<PostEntity>> getPostsByHashtag(String hashtag) => remote.getPostsByHashtag(hashtag);
}
