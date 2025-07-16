abstract class UserProfileEvent {}

class LoadUserProfileEvent extends UserProfileEvent {
  final String uid;
  LoadUserProfileEvent(this.uid);
}