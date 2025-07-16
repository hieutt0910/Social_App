import 'package:social_app/domain/entity/post.dart';
import 'package:social_app/domain/repositories/post_repository.dart';

class UpdatePostUseCase {
  final PostRepository repository;
  UpdatePostUseCase(this.repository);

  Future<void> call(PostEntity updatedPost) {
    return repository.updatePost(updatedPost);
  }
}
