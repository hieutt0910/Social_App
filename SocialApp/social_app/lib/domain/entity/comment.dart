import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final String? parentCommentId;
  final List<String> likedBy; 

  const Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.parentCommentId,
    this.likedBy = const [], 
  });

  int get likesCount => likedBy.length;

  bool isLikedBy(String uid) => likedBy.contains(uid);


  Comment copyWith({
    String? content,
    List<String>? likedBy,
    String? parentCommentId,
  }) {
    return Comment(
      id: id,
      postId: postId,
      userId: userId,
      content: content ?? this.content,
      createdAt: createdAt,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      likedBy: likedBy ?? this.likedBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        postId,
        userId,
        content,
        createdAt,
        parentCommentId,
        likedBy,
      ];
}