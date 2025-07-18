import 'package:social_app/domain/entity/post.dart';
import 'package:social_app/domain/repositories/post_repository.dart';

class GetPostsByHashtagUseCase {
  final PostRepository repository;

  GetPostsByHashtagUseCase(this.repository);
  Stream<List<PostEntity>> call(String hashtag) {
    return repository.getPostsByHashtag(hashtag);
  }
}
