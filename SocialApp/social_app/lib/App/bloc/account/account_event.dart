abstract class AccountEvent {}

class LoadUserEvent extends AccountEvent {
  final String uid;
  LoadUserEvent(this.uid);
}

class SignOutEvent extends AccountEvent {}