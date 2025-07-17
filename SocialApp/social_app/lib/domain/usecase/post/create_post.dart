import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:social_app/domain/entity/post.dart';
import 'package:social_app/domain/repositories/post_repository.dart';

class CreatePostUseCase {
  final PostRepository _repo;
  final Uuid _uuid = const Uuid();

  CreatePostUseCase(this._repo);

  Future<void> call({
    required String caption,
    required List<File> images,
    required String userId,
    List<String> hashtags = const [], 
  }) async {
    if (caption.trim().isEmpty && images.isEmpty) {
      throw Exception('Bạn chưa nhập nội dung hoặc chọn ảnh');
    }

    final postId = _uuid.v4();

    final imageUrls = await _repo.uploadImages(postId, images);

    final post = PostEntity(
      id: postId,
      userId: userId,
      caption: caption,
      imageUrls: imageUrls,
      createdAt: DateTime.now(),
      likedBy: const [],
      commentsCount: 0,
      hashtags: hashtags, 
      viewsCount: 0
    );

    await _repo.createPost(post);
  }
}
