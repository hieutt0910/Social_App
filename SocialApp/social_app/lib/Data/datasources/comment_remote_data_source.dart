import 'package:social_app/domain/entity/comment.dart';

abstract class CommentRemoteDataSource {
  Future<void> createComment(Comment comment);

  Stream<List<Comment>> getComments(String postId);

  Future<void> deleteComment(String commentId);

  Future<void> likeComment(String commentId, String uid);

  Future<void> unlikeComment(String commentId, String uid);
  
}
