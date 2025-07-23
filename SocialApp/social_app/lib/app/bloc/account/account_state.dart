import '../../../data/model/user.dart';

abstract class AccountState {}

class AccountLoading extends AccountState {}

class AccountLoadSuccess extends AccountState {
  final AppUser user;

  AccountLoadSuccess(this.user);
}

class AccountLoadFailure extends AccountState {
  final String error;

  AccountLoadFailure(this.error);
}

class AccountSignOutSuccess extends AccountState {}