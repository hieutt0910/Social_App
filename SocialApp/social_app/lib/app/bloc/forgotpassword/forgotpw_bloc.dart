import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Data/Repositories/dynamic_link_handler.dart';
import 'forgotpw_event.dart';
import 'forgotpw_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<SendResetLinkEvent>(_onSendResetLink);
  }

  Future<void> _onSendResetLink(
      SendResetLinkEvent event, Emitter<ForgotPasswordState> emit) async {
    if (state is ForgotPasswordLoading) return;
    emit(ForgotPasswordLoading());

    try {
      if (!event.email.contains('@')) {
        emit(const ForgotPasswordFailure('Vui lòng nhập địa chỉ email hợp lệ'));
        return;
      }

      if (event.email.isEmpty) {
        emit(const ForgotPasswordFailure('Vui lòng nhập email'));
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pending_email', event.email);

      await DynamicLinksHandler.sendSignInLink(event.email, fromRoute: 'forgot_password');
      emit(ForgotPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Không tìm thấy người dùng với email này.';
          break;
        case 'invalid-email':
          errorMessage = 'Địa chỉ email không hợp lệ.';
          break;
        default:
          errorMessage = 'Lỗi: ${e.message}';
      }
      emit(ForgotPasswordFailure(errorMessage));
    } catch (e) {
      emit(ForgotPasswordFailure('Lỗi khi gửi liên kết đặt lại: $e'));
    }
  }
}