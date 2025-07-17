import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:social_app/domain/entity/post.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
  @override
  List<Object?> get props => [];
}

class PostCreateRequested extends PostEvent {
  final String caption;
  final List<File> images;
  final String userId;
  final List<String> hashtags;

  const PostCreateRequested({
    required this.caption,
    required this.images,
    required this.userId,
    required this.hashtags,
  });

  @override
  List<Object?> get props => [caption, images, userId, hashtags];
}

class PostFetchRequested extends PostEvent {
  const PostFetchRequested();
}

class PostToggleLikeRequested extends PostEvent {
  final PostEntity post;
  final String userId;

  const PostToggleLikeRequested(this.post, this.userId);

  @override
  List<Object?> get props => [post, userId];
}

class PostDeleteRequested extends PostEvent {
  final String postId;

  const PostDeleteRequested(this.postId);

  @override
  List<Object?> get props => [postId];
}

class PostsArrived extends PostEvent {
  final List<PostEntity> posts;

  const PostsArrived(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostsError extends PostEvent {
  final Object error;

  const PostsError(this.error);

  @override
  List<Object?> get props => [error];
}

class PostViewIncreaseRequested extends PostEvent {
  final String postId;
  const PostViewIncreaseRequested(this.postId);
}

class PostByHashtagRequested extends PostEvent {
  final String hashtag;
  const PostByHashtagRequested(this.hashtag);
}
class PostByUserIdRequested extends PostEvent {
  final String userId;
  const PostByUserIdRequested(this.userId);
}
class PostEditRequested extends PostEvent {
  final PostEntity updatedPost;

  const PostEditRequested(this.updatedPost);

  @override
  List<Object?> get props => [updatedPost];
}

class PostSearchRequested extends PostEvent {
  final String query;
  final String currentTab; 
  final String userId; 

  const PostSearchRequested({
    required this.query,
    required this.currentTab,
    required this.userId,
  });
}
