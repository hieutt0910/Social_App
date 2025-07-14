import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/app/bloc/post/post_event.dart';
import 'package:social_app/app/bloc/post/post_state.dart';
import 'package:social_app/domain/entity/post.dart';
import 'package:social_app/domain/usecase/post/create_post.dart';
import 'package:social_app/domain/usecase/post/get_post.dart';
import 'package:social_app/domain/usecase/post/toggle_like_post.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final CreatePostUseCase _createPost;
  final GetPostsUseCase _getPosts;
  final ToggleLikeUseCase _toggleLike;

  StreamSubscription<List<PostEntity>>? _postsSub;

  PostBloc({
    required CreatePostUseCase createPost,
    required GetPostsUseCase getPosts,
    required ToggleLikeUseCase toggleLike,
  }) : _createPost = createPost,
       _getPosts = getPosts,
       _toggleLike = toggleLike,
       super(PostInitial()) {
    on<PostCreateRequested>(_onCreate);
    on<PostFetchRequested>(_onFetch);
    on<PostToggleLikeRequested>(_onToggleLike);
    on<_PostsArrived>((event, emit) => emit(PostListLoaded(event.posts)));
    on<_PostsError>((event, emit) => emit(PostFailure(event.error.toString())));
  }

  Future<void> _onCreate(PostCreateRequested e, Emitter<PostState> emit) async {
    if (e.caption.isEmpty && e.images.isEmpty) {
      emit(const PostFailure('Bạn chưa nhập nội dung hoặc chọn ảnh'));
      return;
    }

    emit(PostLoading());

    try {
      await _createPost(caption: e.caption, images: e.images, userId: e.userId);
      emit(PostSuccess());
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }

  Future<void> _onFetch(
    PostFetchRequested event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());

    await _postsSub?.cancel();
    _postsSub = _getPosts().listen(
      (posts) => add(_PostsArrived(posts)),
      onError: (err) => add(_PostsError(err)),
    );
  }

  Future<void> _onToggleLike(
    PostToggleLikeRequested e,
    Emitter<PostState> emit,
  ) async {
    try {
      await _toggleLike(e.post, e.userId);
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }

  @override
  Future<void> close() {
    _postsSub?.cancel();
    return super.close();
  }
}

class _PostsArrived extends PostEvent {
  final List<PostEntity> posts;
  const _PostsArrived(this.posts);
  @override
  List<Object?> get props => [posts];
}

class _PostsError extends PostEvent {
  final Object error;
  const _PostsError(this.error);
  @override
  List<Object?> get props => [error];
}
