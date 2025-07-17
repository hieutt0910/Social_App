import 'package:cloud_firestore/cloud_firestore.dart';

class Shot {
  final String id;
  final String imageUrl;
  final String ownerId;

  Shot({
    required this.id,
    required this.imageUrl,
    required this.ownerId,
  });

  factory Shot.fromMap(Map<String, dynamic> data, String id) {
    return Shot(
      id: id,
      imageUrl: data['imageUrl'] ?? '',
      ownerId: data['ownerId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'ownerId': ownerId,
    };
  }

  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance
        .collection('shots')
        .doc(id)
        .set(toMap());
  }

  Future<void> updateToFirestore(Map<String, dynamic> updates) async {
    try {
      await FirebaseFirestore.instance
          .collection('shots')
          .doc(id)
          .update(updates);
      print('Updated shot: $id with $updates');
    } catch (e) {
      print('Error updating shot: $e');
    }
  }

  static Future<List<Shot>> getUserShots(String userId) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('shots')
          .where('ownerId', isEqualTo: userId)
          .get();
      return query.docs
          .map((doc) {
        return Shot.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      })
          .toList();
    } catch (e) {
      print('Error fetching shots: $e');
      return [];
    }
  }
}