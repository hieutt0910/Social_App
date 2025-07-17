import '../../entity/user.dart';
import '../../repositories/user_repository.dart';

class SaveUserUseCase {
  final UserRepository repository;

  SaveUserUseCase(this.repository);

  Future<void> execute(AppUser user) async {
    await repository.saveUser(user);
  }
}