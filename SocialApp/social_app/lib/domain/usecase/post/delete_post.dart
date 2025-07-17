import 'package:social_app/domain/repositories/post_repository.dart';

class DeletePostUseCase {
  final PostRepository repository;
  DeletePostUseCase(this.repository);

  Future<void> call(String postId) => repository.deletePost(postId);
}
