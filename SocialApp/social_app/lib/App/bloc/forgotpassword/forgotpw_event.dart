import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class SendResetLinkEvent extends ForgotPasswordEvent {
  final String email;

  const SendResetLinkEvent(this.email);

  @override
  List<Object> get props => [email];
}