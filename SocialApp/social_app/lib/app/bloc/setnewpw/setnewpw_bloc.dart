import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'setnewpw_event.dart';
import 'setnewpw_state.dart';

class SetNewPasswordBloc extends Bloc<SetNewPasswordEvent, SetNewPasswordState> {
  final String email;

  SetNewPasswordBloc({required this.email}) : super(SetNewPasswordInitial()) {
    on<UpdatePasswordEvent>(_onUpdatePassword);
  }

  Future<void> _onUpdatePassword(
      UpdatePasswordEvent event, Emitter<SetNewPasswordState> emit) async {
    if (state is SetNewPasswordLoading) return;
    emit(SetNewPasswordLoading());

    try {
      if (event.oldPassword.isEmpty ||
          event.newPassword.isEmpty ||
          event.confirmPassword.isEmpty) {
        emit(const SetNewPasswordFailure('Vui lòng điền đầy đủ các trường'));
        return;
      }

      if (event.newPassword != event.confirmPassword) {
        emit(const SetNewPasswordFailure('Mật khẩu mới không khớp'));
        return;
      }

      if (event.newPassword.length < 6) {
        emit(const SetNewPasswordFailure('Mật khẩu mới phải có ít nhất 6 ký tự'));
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: event.oldPassword,
      );

      await FirebaseAuth.instance.currentUser!.updatePassword(event.newPassword);

      emit(SetNewPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Không tìm thấy người dùng với email này.';
          break;
        case 'wrong-password':
          errorMessage = 'Mật khẩu cũ không đúng.';
          break;
        case 'requires-recent-login':
          errorMessage = 'Vui lòng đăng nhập lại và thử lại.';
          break;
        default:
          errorMessage = 'Lỗi: ${e.message}';
      }
      emit(SetNewPasswordFailure(errorMessage));
    } catch (e) {
      emit(SetNewPasswordFailure('Lỗi khi đặt mật khẩu mới: $e'));
    }
  }
}