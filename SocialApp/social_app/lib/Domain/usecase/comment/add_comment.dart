import 'package:social_app/domain/repositories/comment_repository.dart';

class AddComment {
  final CommentRepository repository;

  AddComment(this.repository);

  Future<void> call(String postId, String userId, String content, {String? parentCommentId}) {
    return repository.addComment(postId, userId, content, parentCommentId: parentCommentId);
  }
}