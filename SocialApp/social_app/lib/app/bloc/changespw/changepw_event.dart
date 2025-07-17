abstract class ChangePasswordEvent {
  const ChangePasswordEvent();
}

class UpdatePasswordEvent extends ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const UpdatePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
}