import '../../entity/user.dart';
import '../../repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Future<AppUser?> execute(String uid) async {
    return await repository.getUser(uid);
  }
}