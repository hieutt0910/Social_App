import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

abstract class UserRemoteDataSource {
  Future<AppUser?> getUser(String uid);
  Future<void> saveUser(AppUser user);
  Future<void> updateUser(String uid, Map<String, dynamic> updates);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl({required this.firestore});

  @override
  Future<AppUser?> getUser(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data()!, uid);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  @override
  Future<void> saveUser(AppUser user) async {
    try {
      await firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      throw Exception('Error saving user: $e');
    }
  }

  @override
  Future<void> updateUser(String uid, Map<String, dynamic> updates) async {
    try {
      await firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }
}