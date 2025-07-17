
import 'package:social_app/domain/entity/comment.dart';
import 'package:social_app/domain/repositories/comment_repository.dart';

class ToggleLikeCommentUseCase {
  final CommentRepository repository;

  ToggleLikeCommentUseCase(this.repository);

  Future<bool> call(Comment comment, String userId) async {
    final alreadyLiked = comment.likedBy.contains(userId);

    if (alreadyLiked) {
      await repository.unlikeComment(comment.id, userId);
      return false; 
    } else {
      await repository.likeComment(comment.id, userId);
      return true; 
    }
  }
}