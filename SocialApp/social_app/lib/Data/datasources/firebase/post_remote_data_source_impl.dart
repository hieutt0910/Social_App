import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:social_app/data/model/post.dart';
import 'package:social_app/data/servives/cloudinary_service.dart';
import 'package:social_app/domain/entity/post.dart';
import 'package:social_app/data/datasources/post_remote_data_source.dart';

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final FirebaseFirestore _firestore;
  final CloudinaryService _cloudinaryService;
  CollectionReference<Map<String, dynamic>> get _postCol =>
      _firestore.collection('posts');
  PostRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    required CloudinaryService cloudinaryService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _cloudinaryService = cloudinaryService;

  @override
  Future<List<String>> uploadImages(String postId, List<File> images) async {
    final List<String> urls = [];

    for (final file in images) {
      try {
        final url = await _cloudinaryService.uploadImage(file);
        print('Uploaded image URL: $url');
        urls.add(url);
      } catch (e) {
        print('Lỗi upload ảnh: $e');
      }
    }

    return urls;
  }

  @override
  Future<void> createPost(PostEntity post) async {
    final model = PostModel.fromEntity(post);
    await _firestore.collection('posts').doc(post.id).set(model.toMap());
  }

  @override
  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }

  @override
  Future<void> likePost(String postId, String uid) async {
    await _firestore.collection('posts').doc(postId).update({
      'likedBy': FieldValue.arrayUnion([uid]),
    });
  }

  @override
  Future<void> unlikePost(String postId, String uid) async {
    await _firestore.collection('posts').doc(postId).update({
      'likedBy': FieldValue.arrayRemove([uid]),
    });
  }

  @override
  Future<void> incrementViews(String postId) async {
    final docRef = _firestore.collection('posts').doc(postId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) return;

      final currentViews = snapshot.data()?['viewsCount'] ?? 0;
      transaction.update(docRef, {'viewsCount': (currentViews as int) + 1});
    });
  }

  @override
  Stream<List<PostEntity>> getPostsByHashtag(String hashtag) {
    return _postCol
        .where('hashtags', arrayContains: hashtag)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs
                  .map((d) => PostModel.fromMap(d.data(), d.id).toEntity())
                  .toList(),
        );
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    final model = PostModel.fromEntity(post);
    await _firestore.collection('posts').doc(post.id).update(model.toMap());
  }

  @override
  Stream<List<PostEntity>> getPostsByCondition({String? hashtag, String? uid}) {
    Query query = _postCol;

    if (hashtag != null) {
      query = query.where('hashtags', arrayContains: hashtag);
    }

    if (uid != null) {
      query = query.where('uid', isEqualTo: uid);
    }

    query = query.orderBy('createdAt', descending: true);

    return query.snapshots().map(
      (snap) =>
          snap.docs
              .map(
                (d) =>
                    PostModel.fromMap(
                      d.data() as Map<String, dynamic>,
                      d.id,
                    ).toEntity(),
              )
              .toList(),
    );
  }
}
