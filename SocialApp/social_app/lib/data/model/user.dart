import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  String name;
  String lastName;
  String location;
  String? imageUrl;
  String? instagram;
  String? twitter;
  String? website;
  String? terms;
  int followers;
  int following;

  AppUser({
    required this.uid,
    required this.email,
    this.name = 'Unknown',
    this.lastName = '',
    this.location = '',
    this.imageUrl,
    this.instagram,
    this.twitter,
    this.website,
    this.terms,
    this.followers = 0,
    this.following = 0,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? 'Unknown',
      lastName: data['lastName'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'],
      instagram: data['instagram'],
      twitter: data['twitter'],
      website: data['website'],
      terms: data['terms'],
      followers: data['followers'] ?? 0,
      following: data['following'] ?? 0,
    );
  }

  // Chuyển đổi đối tượng AppUser sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'lastName': lastName,
      'location': location,
      'imageUrl': imageUrl,
      'instagram': instagram,
      'twitter': twitter,
      'website': website,
      'terms': terms,
      'followers': followers,
      'following': following,
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
    String? location,
    String? imageUrl,
    String? instagram,
    String? twitter,
    String? website,
    String? terms,
    int? followers,
    int? following,
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
    if (location != null) {
      this.location = location;
      updates['location'] = location;
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
    if (followers != null) {
      this.followers = followers;
      updates['followers'] = followers;
    }
    if (following != null) {
      this.following = following;
      updates['following'] = following;
    }
    if (updates.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(updates);
    }
  }

  // Kiểm tra xem người dùng hiện tại có đang theo dõi người dùng khác không
  Future<bool> isFollowing(String otherUserId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('following')
        .doc(otherUserId)
        .get();
    return doc.exists;
  }

  // Theo dõi một người dùng
  Future<void> followUser(String otherUserId) async {
    final batch = FirebaseFirestore.instance.batch();

    // Thêm otherUserId vào following của người dùng hiện tại
    batch.set(
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('following')
          .doc(otherUserId),
      {'timestamp': Timestamp.now()},
    );

    // Thêm uid vào followers của người dùng được theo dõi
    batch.set(
      FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserId)
          .collection('followers')
          .doc(uid),
      {'timestamp': Timestamp.now()},
    );

    // Tăng following của người dùng hiện tại
    batch.update(
      FirebaseFirestore.instance.collection('users').doc(uid),
      {'following': FieldValue.increment(1)},
    );

    // Tăng followers của người dùng được theo dõi
    batch.update(
      FirebaseFirestore.instance.collection('users').doc(otherUserId),
      {'followers': FieldValue.increment(1)},
    );

    await batch.commit();
    // Cập nhật local state
    following++;
  }

  // Bỏ theo dõi một người dùng
  Future<void> unfollowUser(String otherUserId) async {
    final batch = FirebaseFirestore.instance.batch();

    // Xóa otherUserId khỏi following của người dùng hiện tại
    batch.delete(
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('following')
          .doc(otherUserId),
    );

    // Xóa uid khỏi followers của người dùng được theo dõi
    batch.delete(
      FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserId)
          .collection('followers')
          .doc(uid),
    );

    // Giảm following của người dùng hiện tại
    batch.update(
      FirebaseFirestore.instance.collection('users').doc(uid),
      {'following': FieldValue.increment(-1)},
    );

    // Giảm followers của người dùng được theo dõi
    batch.update(
      FirebaseFirestore.instance.collection('users').doc(otherUserId),
      {'followers': FieldValue.increment(-1)},
    );

    await batch.commit();
    // Cập nhật local state
    following--;
  }
}