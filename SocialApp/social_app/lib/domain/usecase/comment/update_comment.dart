import 'package:social_app/domain/repositories/comment_repository.dart';

class UpdateComment {
  final CommentRepository repository;

  UpdateComment(this.repository);

  Future<void> call(String commentId, String newContent) {
    return repository.updateComment(commentId, newContent);
  }
}