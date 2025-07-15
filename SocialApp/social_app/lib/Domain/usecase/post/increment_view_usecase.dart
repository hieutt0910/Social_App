import 'package:social_app/domain/repositories/post_repository.dart';

class IncrementViewUseCase {
  final PostRepository _repository;

  IncrementViewUseCase(this._repository);

  Future<void> call(String postId) {
    return _repository.incrementViews(postId);
  }
}
