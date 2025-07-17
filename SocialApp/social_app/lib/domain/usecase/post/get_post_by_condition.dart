import 'package:social_app/domain/entity/post.dart';
import 'package:social_app/domain/repositories/post_repository.dart';

class GetPostsByConditionUseCase {
  final PostRepository repository;

  GetPostsByConditionUseCase(this.repository);

  Stream<List<PostEntity>> call({String? hashtag, String? uid}) {
    return repository.getPostsByCondition(hashtag: hashtag, uid: uid);
  }
}
