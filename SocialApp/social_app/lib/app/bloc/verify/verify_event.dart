import 'package:equatable/equatable.dart';

abstract class VerifyEvent extends Equatable {
  const VerifyEvent();

  @override
  List<Object> get props => [];
}

class VerifyOTPEvent extends VerifyEvent {
  final String otp;

  const VerifyOTPEvent(this.otp);

  @override
  List<Object> get props => [otp];
}

class ResendLinkEvent extends VerifyEvent {}