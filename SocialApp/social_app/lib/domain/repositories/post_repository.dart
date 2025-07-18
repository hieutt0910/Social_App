import 'dart:io';
import 'package:social_app/domain/entity/post.dart';

abstract class PostRepository {
  Future<List<String>> uploadImages(String postId, List<File> images);
  Future<void> createPost(PostEntity post);
  Stream<List<PostEntity>> getPostsByCondition({String? hashtag, String? uid});
  Stream<List<PostEntity>> getPostsByHashtag(String hashtag);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(String postId);
  Future<void> likePost(String postId, String userId);
  Future<void> unlikePost(String postId, String userId);
  Future<void> incrementViews(String postId);
}
