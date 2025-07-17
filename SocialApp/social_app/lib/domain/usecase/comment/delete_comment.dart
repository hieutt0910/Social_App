import 'package:social_app/domain/repositories/comment_repository.dart';

class DeleteComment {
  final CommentRepository repository;

  DeleteComment(this.repository);

  Future<void> call(String postId, String commentId) {
    return repository.deleteComment(postId, commentId);
  }
}