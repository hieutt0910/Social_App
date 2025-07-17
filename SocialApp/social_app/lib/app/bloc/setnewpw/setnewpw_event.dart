import 'package:equatable/equatable.dart';

abstract class SetNewPasswordEvent extends Equatable {
  const SetNewPasswordEvent();

  @override
  List<Object> get props => [];
}

class UpdatePasswordEvent extends SetNewPasswordEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const UpdatePasswordEvent(this.oldPassword, this.newPassword, this.confirmPassword);

  @override
  List<Object> get props => [oldPassword, newPassword, confirmPassword];
}