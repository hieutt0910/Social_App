import '../../../Domain/entity/user.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final AppUser user;
  UserProfileLoaded(this.user);
}

class UserProfileError extends UserProfileState {
  final String message;
  UserProfileError(this.message);
}