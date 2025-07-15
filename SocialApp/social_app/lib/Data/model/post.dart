import 'package:firebase_database/firebase_database.dart';
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
    required super.hashtags,
    required super.viewsCount, 
  });

  factory PostModel.fromMap(Map<dynamic, dynamic> map, String id) {
    DateTime parseCreatedAt(dynamic raw) {
      if (raw is int) {
        return DateTime.fromMillisecondsSinceEpoch(raw);
      } else if (raw is String) {
        return int.tryParse(raw) != null
            ? DateTime.fromMillisecondsSinceEpoch(int.parse(raw))
            : DateTime.parse(raw);
      } else {
        return DateTime.now();
      }
    }

    return PostModel(
      id: id,
      userId: map['userId'] as String,
      caption: map['caption'] as String,
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      createdAt: parseCreatedAt(map['createdAt']),
      likedBy: List<String>.from(map['likedBy'] ?? []),
      commentsCount: map['commentsCount'] as int? ?? 0,
      hashtags: List<String>.from(map['hashtags'] ?? []),
      viewsCount: map['viewsCount'] as int? ?? 0, 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'caption': caption,
      'imageUrls': imageUrls,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'likedBy': likedBy,
      'commentsCount': commentsCount,
      'hashtags': hashtags,
      'viewsCount': viewsCount, 
    };
  }

  Map<String, dynamic> toMapForCreation() {
    return {
      'userId': userId,
      'caption': caption,
      'imageUrls': imageUrls,
      'createdAt': ServerValue.timestamp,
      'likedBy': const [],
      'commentsCount': 0,
      'hashtags': hashtags,
      'viewsCount': 0, 
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
        hashtags: e.hashtags,
        viewsCount: e.viewsCount, 
      );

  PostEntity toEntity() => PostEntity(
        id: id,
        userId: userId,
        caption: caption,
        imageUrls: imageUrls,
        createdAt: createdAt,
        likedBy: likedBy,
        commentsCount: commentsCount,
        hashtags: hashtags,
        viewsCount: viewsCount, 
      );
}
