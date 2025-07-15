import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_event.dart';
import 'signup_state.dart';
import '../../../Data/Repositories/dynamic_link_handler.dart';
import '../../../Data/model/user.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpWithEmailEvent>(_onSignUpWithEmail);
  }

  Future<void> _onSignUpWithEmail(
      SignUpWithEmailEvent event, Emitter<SignUpState> emit) async {
    if (state is SignUpLoading) return;
    emit(SignUpLoading());

    try {
      if (!event.email.contains('@')) {
        emit(const SignUpFailure('Vui lòng nhập địa chỉ email hợp lệ'));
        return;
      }

      if (event.email.isEmpty ||
          event.password.isEmpty ||
          event.confirmPassword.isEmpty) {
        emit(const SignUpFailure('Vui lòng điền đầy đủ các trường'));
        return;
      }

      if (event.password != event.confirmPassword) {
        emit(const SignUpFailure('Mật khẩu không khớp'));
        return;
      }

      if (event.password.length < 6) {
        emit(const SignUpFailure('Mật khẩu phải có ít nhất 6 ký tự'));
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pending_email', event.email);
      await prefs.setString('temp_password', event.password);

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: event.email, password: event.password);

      if (userCredential.user != null) {
        final appUser = AppUser(
          uid: userCredential.user!.uid,
          email: event.email,
        );
        await appUser.saveToFirestore();
      }

      await DynamicLinksHandler.sendSignInLink(event.email);
      emit(SignUpSuccess());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Địa chỉ email đã được sử dụng.';
          break;
        case 'invalid-email':
          errorMessage = 'Địa chỉ email không hợp lệ.';
          break;
        case 'weak-password':
          errorMessage = 'Mật khẩu quá yếu.';
          break;
        default:
          errorMessage = 'Lỗi: ${e.message}';
      }
      emit(SignUpFailure(errorMessage));
    } catch (e) {
      emit(SignUpFailure('Lỗi khi đăng ký: $e'));
    }
  }
}