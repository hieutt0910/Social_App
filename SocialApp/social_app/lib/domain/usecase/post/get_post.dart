import 'package:social_app/domain/entity/post.dart';
import 'package:social_app/domain/repositories/post_repository.dart';

class GetPostsUseCase {
  final PostRepository repository;
  GetPostsUseCase(this.repository);

  Stream<List<PostEntity>> call() => repository.getPosts();
}
