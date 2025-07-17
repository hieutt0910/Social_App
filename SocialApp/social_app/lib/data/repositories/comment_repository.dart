import 'package:firebase_database/firebase_database.dart';
import 'package:social_app/data/datasources/comment_remote_data_source.dart';
import 'package:social_app/data/model/comment.dart';
import 'package:social_app/domain/entity/comment.dart';

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  DatabaseReference _postCommentsRef(String postId) =>
      _db.child('comments').child(postId);

  @override
  Future<void> createComment(Comment comment) async {
    final commentModel = CommentModel.fromEntity(comment);
    final ref = _postCommentsRef(comment.postId).child(comment.id);
    await ref.set(commentModel.toMapForCreation());
  }

  @override
  Stream<List<Comment>> getComments(String postId) {
    final ref = _postCommentsRef(postId);
    return ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return [];

      return data.entries
          .map((e) => CommentModel.fromMap(e.value, e.key).toEntity())
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  @override
  Future<void> deleteComment(String commentId) async {
    final parts = commentId.split('_');
    final postId = parts.first;
    final ref = _postCommentsRef(postId).child(commentId);
    await ref.remove();
  }

  @override
  Future<void> likeComment(String commentId, String uid) async {
    final parts = commentId.split('_');
    final postId = parts.first;
    final ref = _postCommentsRef(postId).child(commentId).child('likedBy');
    await ref.runTransaction((value) {
      final list = (value as List<dynamic>? ?? []).cast<String>();
      if (!list.contains(uid)) list.add(uid);
      return Transaction.success(list);
    });
  }

  @override
  Future<void> unlikeComment(String commentId, String uid) async {
    final parts = commentId.split('_');
    final postId = parts.first;
    final ref = _postCommentsRef(postId).child(commentId).child('likedBy');
    await ref.runTransaction((value) {
      final list = (value as List<dynamic>? ?? []).cast<String>();
      list.remove(uid);
      return Transaction.success(list);
    });
  }
}
