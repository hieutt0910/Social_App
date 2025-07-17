import 'package:firebase_database/firebase_database.dart';
import 'package:social_app/domain/entity/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.postId,
    required super.userId,
    required super.content,
    required super.createdAt,
    super.parentCommentId,
    super.likedBy = const [],
  });

  factory CommentModel.fromMap(Map<dynamic, dynamic> map, String id) {
    final int? timestamp = map['timestamp'] as int?;
    return CommentModel(
      id: id,
      postId: map['postId'] as String,
      userId: map['userId'] as String,
      content: map['content'] as String,
      createdAt: timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : DateTime.now(),
      parentCommentId: map['parentCommentId'] as String?,
      likedBy: List<String>.from(map['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'content': content,
      'timestamp': createdAt.millisecondsSinceEpoch,
      'parentCommentId': parentCommentId,
      'likedBy': likedBy,
    };
  }

  Map<String, dynamic> toMapForCreation() {
    return {
      'postId': postId,
      'userId': userId,
      'content': content,
      'timestamp': ServerValue.timestamp,
      'parentCommentId': parentCommentId,
      'likedBy': const [],
    };
  }

  factory CommentModel.fromEntity(Comment comment) => CommentModel(
        id: comment.id,
        postId: comment.postId,
        userId: comment.userId,
        content: comment.content,
        createdAt: comment.createdAt,
        parentCommentId: comment.parentCommentId,
        likedBy: comment.likedBy,
      );

  Comment toEntity() => Comment(
        id: id,
        postId: postId,
        userId: userId,
        content: content,
        createdAt: createdAt,
        parentCommentId: parentCommentId,
        likedBy: likedBy,
      );
}
