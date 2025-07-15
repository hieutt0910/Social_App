import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  String name;
  String lastName;
  String? imageUrl;
  String? instagram;
  String? twitter;
  String? website;
  String? terms;

  AppUser({
    required this.uid,
    required this.email,
    this.name = 'Unknown',
    this.lastName = '',
    this.imageUrl,
    this.instagram,
    this.twitter,
    this.website,
    this.terms,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? 'Unknown',
      lastName: data['lastName'] ?? '',
      imageUrl: data['imageUrl'],
      instagram: data['instagram'],
      twitter: data['twitter'],
      website: data['website'],
      terms: data['terms'],
    );
  }

  // Chuyển đổi đối tượng AppUser sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'lastName': lastName,
      'imageUrl': imageUrl,
      'instagram': instagram,
      'twitter': twitter,
      'website': website,
      'terms': terms,
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
    String? instagram,
    String? twitter,
    String? website,
    String? terms,
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
    if (instagram != null) {
      this.instagram = instagram;
      updates['instagram'] = instagram;
    }
    if (twitter != null) {
      this.twitter = twitter;
      updates['twitter'] = twitter;
    }
    if (website != null) {
      this.website = website;
      updates['website'] = website;
    }
    if (terms != null) {
      this.terms = terms;
      updates['terms'] = terms;
    }
    if (updates.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(updates);
    }
  }
}