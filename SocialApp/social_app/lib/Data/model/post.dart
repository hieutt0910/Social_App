import 'package:social_app/domain/entity/post.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.userId,
    required super.caption,
    required super.imageUrls,
    required super.createdAt,
    required super.likedBy,
    required super.commentsCount,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      userId: map['userId'],
      caption: map['caption'],
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      likedBy: List<String>.from(map['likedBy'] ?? []),
      commentsCount: map['commentsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'caption': caption,
      'imageUrls': imageUrls,
      'createdAt': createdAt.toIso8601String(),
      'likedBy': likedBy,
      'commentsCount': commentsCount,
    };
  }

  factory PostModel.fromEntity(PostEntity e) => PostModel(
    id: e.id,
    userId: e.userId,
    caption: e.caption,
    imageUrls: e.imageUrls,
    createdAt: e.createdAt,
    likedBy: e.likedBy,
    commentsCount: e.commentsCount,
  );

  PostEntity toEntity() => PostEntity(
    id: id,
    userId: userId,
    caption: caption,
    imageUrls: imageUrls,
    createdAt: createdAt,
    likedBy: likedBy,
    commentsCount: commentsCount,
  );
}
