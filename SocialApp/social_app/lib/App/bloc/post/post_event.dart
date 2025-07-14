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

  const PostCreateRequested({
    required this.caption,
    required this.images,
    required this.userId,
  });

  @override
  List<Object?> get props => [caption, images, userId];
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
