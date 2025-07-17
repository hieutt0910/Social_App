abstract class UserProfileEvent {}

class LoadUserProfileEvent extends UserProfileEvent {
  final String uid;
  LoadUserProfileEvent(this.uid);
}

class ChangeTabEvent extends UserProfileEvent {
  final int tabIndex;
  ChangeTabEvent(this.tabIndex);
}