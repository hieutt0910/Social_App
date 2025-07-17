
import '../entity/user.dart';

abstract class UserRepository {
  Future<AppUser?> getUser(String uid);
  Future<void> saveUser(AppUser user);
  Future<void> updateUser(String uid, Map<String, dynamic> updates);
}