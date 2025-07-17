import 'package:social_app/domain/entity/comment.dart';

abstract class CommentRepository {
  Stream<List<Comment>> getCommentsForPost(String postId);
  Future<void> addComment(
    String postId,
    String userId,
    String content, {
    String? parentCommentId,
  });
  Future<void> updateComment(String commentId, String newContent);
  Future<void> deleteComment(String postId, String commentId);
  Future<void> likeComment(String commentId, String userId);
  Future<void> unlikeComment(String commentId, String userId);
}
