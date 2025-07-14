import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  String name;
  String lastName;
  String? imageUrl;

  AppUser({
    required this.uid,
    required this.email,
    this.name = 'Unknown',
    this.lastName = '',
    this.imageUrl,
  });

  // Chuyển đổi từ Map (Firestore) sang đối tượng AppUser
  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? 'Unknown',
      lastName: data['lastName'] ?? '',
      imageUrl: data['imageUrl'],
    );
  }

  // Chuyển đổi đối tượng AppUser sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'lastName': lastName,
      'imageUrl': imageUrl,
    };
  }

  // Lưu thông tin người dùng vào Firestore
  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(toMap());
  }

  // Lấy thông tin người dùng từ Firestore
  static Future<AppUser?> getFromFirestore(String uid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // Cập nhật thông tin người dùng trong Firestore
  Future<void> updateInFirestore({
    String? name,
    String? lastName,
    String? imageUrl,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) {
      this.name = name;
      updates['name'] = name;
    }
    if (lastName != null) {
      this.lastName = lastName;
      updates['lastName'] = lastName;
    }
    if (imageUrl != null) {
      this.imageUrl = imageUrl;
      updates['imageUrl'] = imageUrl;
    }
    if (updates.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(updates);
    }
  }
}