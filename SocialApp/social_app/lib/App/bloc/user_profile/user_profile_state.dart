import '../../../Data/model/user.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final AppUser user;
  final int selectedTab;

  UserProfileLoaded(this.user, {this.selectedTab = 0});

  UserProfileLoaded copyWith({AppUser? user, int? selectedTab}) {
    return UserProfileLoaded(
      user ?? this.user,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}

class UserProfileError extends UserProfileState {
  final String message;
  UserProfileError(this.message);
}