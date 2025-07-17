import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/app/bloc/post/post_event.dart';
import 'package:social_app/app/bloc/post/post_state.dart';
import 'package:social_app/domain/entity/post.dart';
import 'package:social_app/domain/usecase/post/create_post.dart';
import 'package:social_app/domain/usecase/post/delete_post.dart';
import 'package:social_app/domain/usecase/post/get_post_by_condition.dart';
import 'package:social_app/domain/usecase/post/get_post_by_hashtag.dart';
import 'package:social_app/domain/usecase/post/increment_view_usecase.dart';
import 'package:social_app/domain/usecase/post/toggle_like_post.dart';
import 'package:social_app/domain/usecase/post/update_post.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final CreatePostUseCase _createPost;
  final GetPostsByConditionUseCase _getPostsByContion;
  final GetPostsByHashtagUseCase _getByHashtag;
  final ToggleLikeUseCase _toggleLike;
  final DeletePostUseCase _deletePost;
  final IncrementViewUseCase _incrementView;
  final UpdatePostUseCase _updatePost;
  StreamSubscription<List<PostEntity>>? _postsSub;

  PostBloc({
    required CreatePostUseCase createPost,
    required UpdatePostUseCase updatePost,
    required GetPostsByConditionUseCase getPostsByContion,
    required GetPostsByHashtagUseCase getByHashtag,
    required ToggleLikeUseCase toggleLike,
    required DeletePostUseCase deletePost,
    required IncrementViewUseCase incrementView,
  }) : _createPost = createPost,
       _updatePost = updatePost,
       _getPostsByContion = getPostsByContion,
       _getByHashtag = getByHashtag,
       _toggleLike = toggleLike,
       _deletePost = deletePost,
       _incrementView = incrementView,
       super(PostInitial()) {
    on<PostCreateRequested>(_onCreate);
    on<PostEditRequested>(_onEdit);
    on<PostDeleteRequested>(_onDelete);
    on<PostToggleLikeRequested>(_onToggleLike);
    on<PostViewIncreaseRequested>(_onIncreaseView);
    on<PostFetchRequested>(_onFetchAll);
    on<PostByHashtagRequested>(_onFetchByHashtag);
    on<PostByUserIdRequested>(_onFetchByUserId);
    on<PostsArrived>((e, emit) => emit(PostListLoaded(e.posts)));
    on<PostsError>((e, emit) => emit(PostFailure(e.error.toString())));
  }

  void _listen(Stream<List<PostEntity>> stream) {
    _postsSub?.cancel();
    _postsSub = stream.listen(
      (posts) => add(PostsArrived(posts)),
      onError: (err) => add(PostsError(err)),
    );
  }

  Future<void> _onFetchAll(
    PostFetchRequested e,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());
    _listen(_getPostsByContion());
  }

  Future<void> _onFetchByHashtag(
    PostByHashtagRequested e,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());
    _listen(_getByHashtag(e.hashtag));
  }

  Future<void> _onFetchByUserId(
    PostByUserIdRequested e,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());
    _listen(_getPostsByContion(uid: e.userId));
  }

  Future<void> _onCreate(PostCreateRequested e, Emitter<PostState> emit) async {
    if (e.caption.isEmpty && e.images.isEmpty) {
      emit(const PostFailure('Bạn chưa nhập nội dung hoặc chọn ảnh'));
      return;
    }
    emit(PostLoading());
    try {
      await _createPost(
        caption: e.caption,
        images: e.images,
        userId: e.userId,
        hashtags: e.hashtags,
      );
      emit(PostSuccess());
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }

  Future<void> _onToggleLike(
    PostToggleLikeRequested e,
    Emitter<PostState> emit,
  ) async {
    final current = state;
    if (current is! PostListLoaded) return;

    final updated =
        current.posts.map((p) {
          if (p.id != e.post.id) return p;
          return e.post.isLikedBy(e.userId)
              ? p.copyWith(likedBy: List.from(p.likedBy)..remove(e.userId))
              : p.copyWith(likedBy: List.from(p.likedBy)..add(e.userId));
        }).toList();

    emit(PostListLoaded(updated));

    try {
      await _toggleLike(e.post, e.userId);
    } catch (err) {
      emit(PostFailure(err.toString()));
      emit(current);
    }
  }

  Future<void> _onDelete(PostDeleteRequested e, Emitter<PostState> emit) async {
    try {
      await _deletePost(e.postId);
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }

  Future<void> _onIncreaseView(
    PostViewIncreaseRequested e,
    Emitter<PostState> emit,
  ) async {
    try {
      await _incrementView(e.postId);
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }

  Future<void> _onEdit(PostEditRequested e, Emitter<PostState> emit) async {
    final current = state;
    if (current is! PostListLoaded) return;

    emit(PostLoading());

    try {
      await _updatePost(e.updatedPost);

      final updatedList =
          current.posts.map((p) {
            return p.id == e.updatedPost.id ? e.updatedPost : p;
          }).toList();

      emit(PostListLoaded(updatedList));
    } catch (err) {
      emit(PostFailure(err.toString()));
      emit(current);
    }
  }

  @override
  Future<void> close() {
    _postsSub?.cancel();
    return super.close();
  }
}
