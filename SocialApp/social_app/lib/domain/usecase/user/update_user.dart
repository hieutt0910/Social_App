import '../../repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<void> execute(String uid, Map<String, dynamic> updates) async {
    await repository.updateUser(uid, updates);
  }
}