import '../../../Domain/entity/user.dart';

abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final AppUser user;
  AccountLoaded(this.user);
}

class AccountError extends AccountState {
  final String message;
  AccountError(this.message);
}

class AccountSignedOut extends AccountState {}