import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'changepw_event.dart';
import 'changepw_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<UpdatePasswordEvent>(_onUpdatePassword);
  }

  Future<void> _onUpdatePassword(
      UpdatePasswordEvent event, Emitter<ChangePasswordState> emit) async {
    if (state is ChangePasswordLoading) return;
    emit(ChangePasswordLoading());

    try {
      if (event.oldPassword.isEmpty ||
          event.newPassword.isEmpty ||
          event.confirmPassword.isEmpty) {
        emit(const ChangePasswordFailure('Please fill in all fields'));
        return;
      }

      if (event.newPassword != event.confirmPassword) {
        emit(const ChangePasswordFailure('New password and confirmation do not match'));
        return;
      }

      if (event.newPassword.length < 6) {
        emit(const ChangePasswordFailure('New password must be at least 6 characters'));
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        emit(const ChangePasswordFailure('No user found. Please sign in again'));
        return;
      }

      // Reauthenticate user with old password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: event.oldPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(event.newPassword);
      emit(ChangePasswordSuccess());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'The old password is incorrect';
          break;
        case 'weak-password':
          errorMessage = 'The new password is too weak';
          break;
        case 'requires-recent-login':
          errorMessage = 'Please sign in again to update your password';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please try again later';
          break;
        default:
          errorMessage = 'Error: ${e.message}';
      }
      emit(ChangePasswordFailure(errorMessage));
    } catch (e) {
      emit(ChangePasswordFailure('Error updating password: $e'));
    }
  }
}