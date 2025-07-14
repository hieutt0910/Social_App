import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:social_app/data/model/post.dart';
import 'package:social_app/data/servives/cloudinary_service.dart';
import 'package:social_app/domain/entity/post.dart';
import 'package:social_app/data/datasources/post_remote_data_source.dart';


class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final FirebaseFirestore _firestore;
  final CloudinaryService _cloudinaryService;

  PostRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    required CloudinaryService cloudinaryService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
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
  Stream<List<PostEntity>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PostModel.fromMap(doc.data()).toEntity())
              .toList(),
        );
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
}
