import 'package:equatable/equatable.dart';

abstract class VerifyState extends Equatable {
  const VerifyState();

  @override
  List<Object> get props => [];
}

class VerifyInitial extends VerifyState {}

class VerifyLoading extends VerifyState {}

class VerifyOtpLoaded extends VerifyState {
  final String otp;
  const VerifyOtpLoaded(this.otp);
}

class VerifySuccess extends VerifyState {}

class VerifyFailure extends VerifyState {
  final String error;

  const VerifyFailure(this.error);

  @override
  List<Object> get props => [error];
}