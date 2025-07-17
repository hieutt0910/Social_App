import 'package:cloud_firestore/cloud_firestore.dart';

class Collection {
  final String id;
  final String title;
  final String coverImage;
  final List<String> imageIds; // Lưu danh sách ID của shots
  final String ownerId;

  Collection({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.imageIds,
    required this.ownerId,
  });

  factory Collection.fromMap(Map<String, dynamic> data, String id) {
    return Collection(
      id: id,
      title: data['title'] ?? '',
      coverImage: data['coverImage'] ?? '',
      imageIds: List<String>.from(data['imageIds'] ?? []),
      ownerId: data['ownerId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'coverImage': coverImage,
      'imageIds': imageIds,
      'ownerId': ownerId,
    };
  }

  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance
        .collection('collections')
        .doc(id)
        .set(toMap());
  }

  Future<void> updateToFirestore(Map<String, dynamic> updates) async {
    try {
      await FirebaseFirestore.instance
          .collection('collections')
          .doc(id)
          .update(updates);
      print('Updated collection: $id with $updates');
    } catch (e) {
      print('Error updating collection: $e');
    }
  }

  static Future<List<Collection>> getUserCollections(String userId) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('collections')
          .where('ownerId', isEqualTo: userId)
          .get();
      return query.docs
          .map((doc) => Collection.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching collections: $e');
      return [];
    }
  }
}