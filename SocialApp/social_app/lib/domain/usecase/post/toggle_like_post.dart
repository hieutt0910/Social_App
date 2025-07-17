import 'package:social_app/domain/repositories/post_repository.dart';

import 'package:social_app/domain/entity/post.dart';

class ToggleLikeUseCase {
  final PostRepository repository;
  ToggleLikeUseCase(this.repository);

  Future<bool> call(PostEntity post, String userId) async {
    final alreadyLiked = post.likedBy.contains(userId);

    if (alreadyLiked) {
      await repository.unlikePost(post.id, userId);
      return false;
    } else {
      await repository.likePost(post.id, userId);
      return true;
    }
  }
}
