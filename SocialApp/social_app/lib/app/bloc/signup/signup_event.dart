import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpWithEmailEvent extends SignUpEvent {
  final String email;
  final String password;
  final String confirmPassword;

  const SignUpWithEmailEvent(this.email, this.password, this.confirmPassword);

  @override
  List<Object> get props => [email, password, confirmPassword];
}