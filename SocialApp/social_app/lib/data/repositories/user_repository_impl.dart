
import '../../Domain/entity/user.dart' as entity;
import '../../Domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../model/user.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<entity.AppUser?> getUser(String uid) async {
    final user = await remoteDataSource.getUser(uid);
    return user != null
        ? entity.AppUser(
      uid: user.uid,
      email: user.email,
      name: user.name,
      lastName: user.lastName,
      location: user.location,
      imageUrl: user.imageUrl,
      instagram: user.instagram,
      twitter: user.twitter,
      website: user.website,
      terms: user.terms,
    )
        : null;
  }

  @override
  Future<void> saveUser(entity.AppUser user) async {
    // Ánh xạ từ entity.AppUser sang AppUser (model)
    final appUser = AppUser(
      uid: user.uid,
      email: user.email,
      name: user.name,
      lastName: user.lastName,
      location: user.location,
      imageUrl: user.imageUrl,
      instagram: user.instagram,
      twitter: user.twitter,
      website: user.website,
      terms: user.terms,
    );
    await remoteDataSource.saveUser(appUser);
  }

  @override
  Future<void> updateUser(String uid, Map<String, dynamic> updates) async {
    await remoteDataSource.updateUser(uid, updates);
  }
}