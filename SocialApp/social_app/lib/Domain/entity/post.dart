

import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final String userId;
  final String caption;
  final List<String> imageUrls;
  final DateTime createdAt;
  final List<String> likedBy;
  final int commentsCount;

  const PostEntity({
    required this.id,
    required this.userId,
    required this.caption,
    required this.imageUrls,
    required this.createdAt,
    required this.likedBy,
    required this.commentsCount,
  });

  int get likesCount => likedBy.length;
  bool isLikedBy(String uid) => likedBy.contains(uid);

  PostEntity copyWith({
    String? caption,
    List<String>? imageUrls,
    List<String>? likedBy,
    int? commentsCount,
  }) {
    return PostEntity(
      id: id,
      userId: userId,
      caption: caption ?? this.caption,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt,
      likedBy: likedBy ?? this.likedBy,
      commentsCount: commentsCount ?? this.commentsCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    caption,
    imageUrls,
    createdAt,
    likedBy,
    commentsCount,
  ];
}
