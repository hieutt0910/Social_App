import 'package:equatable/equatable.dart';

abstract class SetNewPasswordState extends Equatable {
  const SetNewPasswordState();

  @override
  List<Object> get props => [];
}

class SetNewPasswordInitial extends SetNewPasswordState {}

class SetNewPasswordLoading extends SetNewPasswordState {}

class SetNewPasswordSuccess extends SetNewPasswordState {}

class SetNewPasswordFailure extends SetNewPasswordState {
  final String error;

  const SetNewPasswordFailure(this.error);

  @override
  List<Object> get props => [error];
}