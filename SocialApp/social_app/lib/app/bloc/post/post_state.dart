import 'package:equatable/equatable.dart';
import 'package:social_app/domain/entity/post.dart';

abstract class PostState extends Equatable {
  const PostState();
  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostFailure extends PostState {
  final String message;
  const PostFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class PostSuccess extends PostState {}

class PostListLoaded extends PostState {
  final List<PostEntity> posts;
  const PostListLoaded(this.posts);
  @override
  List<Object?> get props => [posts];
}

class PostSearchResultLoaded extends PostState {
  final List<PostEntity> posts;

  const PostSearchResultLoaded(this.posts);
}
