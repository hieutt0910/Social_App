// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../model/user.dart';
//
// abstract class UserRemoteDataSource {
//   Future<UserModel?> getUser(String uid);
//   Future<void> updateUser(String uid, Map<String, dynamic> updates);
//   Future<void> saveUser(UserModel user);
// }
//
// class UserRemoteDataSourceImpl implements UserRemoteDataSource {
//   final FirebaseFirestore firestore;
//
//   UserRemoteDataSourceImpl({required this.firestore});
//
//   @override
//   Future<UserModel?> getUser(String uid) async {
//     try {
//       final doc = await firestore.collection('users').doc(uid).get();
//       if (doc.exists) {
//         return UserModel.fromMap(doc.data()!, uid);
//       }
//       return null;
//     } catch (e) {
//       throw Exception('Error fetching user: $e');
//     }
//   }
//
//   @override
//   Future<void> updateUser(String uid, Map<String, dynamic> updates) async {
//     try {
//       await firestore.collection('users').doc(uid).update(updates);
//     } catch (e) {
//       throw Exception('Error updating user: $e');
//     }
//   }
//
//   @override
//   Future<void> saveUser(UserModel user) async {
//     try {
//       await firestore.collection('users').doc(user.uid).set(user.toMap());
//     } catch (e) {
//       throw Exception('Error saving user: $e');
//     }
//   }
// }