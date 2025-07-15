import 'package:social_app/domain/entity/comment.dart';
import 'package:social_app/domain/repositories/comment_repository.dart';

class GetCommentsForPost {
  final CommentRepository repository;

  GetCommentsForPost(this.repository);

  Stream<List<Comment>> call(String postId) {
    return repository.getCommentsForPost(postId);
  }
}