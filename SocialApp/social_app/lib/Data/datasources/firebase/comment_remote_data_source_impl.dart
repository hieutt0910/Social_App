import 'package:firebase_database/firebase_database.dart';
import 'package:social_app/data/datasources/comment_remote_data_source.dart';
import 'package:social_app/data/model/comment.dart';
import 'package:social_app/domain/entity/comment.dart';

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  DatabaseReference _commentRef(String postId, String commentId) =>
      _db.child('comments').child(postId).child(commentId);

  @override
  Future<void> createComment(Comment comment) async {
    final model = CommentModel.fromEntity(comment);
    final ref = _commentRef(comment.postId, comment.id);
    await ref.set(model.toMapForCreation());
  }

  @override
  Stream<List<Comment>> getComments(String postId) {
    final ref = _db.child('comments').child(postId);
    return ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries
          .map((e) => CommentModel.fromMap(e.value, e.key).toEntity())
          .toList()
        ..sort(
          (a, b) => b.createdAt.compareTo(a.createdAt), 
        );
    });
  }

  @override
  Future<void> deleteComment(String commentId) async {
    final parts = commentId.split('_');
    final postId = parts.first;
    await _commentRef(postId, commentId).remove();
  }

  @override
  Future<void> likeComment(String commentId, String uid) async {
    final parts = commentId.split('_');
    final postId = parts.first;
    final ref = _commentRef(postId, commentId).child('likedBy');
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
    final ref = _commentRef(postId, commentId).child('likedBy');
    await ref.runTransaction((value) {
      final list = (value as List<dynamic>? ?? []).cast<String>();
      list.remove(uid);
      return Transaction.success(list);
    });
  }
}
