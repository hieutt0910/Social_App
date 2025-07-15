import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'verify_event.dart';
import 'verify_state.dart';
import '../../../Data/Repositories/dynamic_link_handler.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  final String email;
  final String fromRoute;

  VerifyBloc({required this.email, required this.fromRoute}) : super(VerifyInitial()) {
    on<VerifyOTPEvent>(_onVerifyOTP);
    on<ResendLinkEvent>(_onResendLink);
    on<ConfirmOTPEvent>(_onConfirmOTP); // Sự kiện mới để xác nhận OTP
  }

  Future<void> _onVerifyOTP(VerifyOTPEvent event, Emitter<VerifyState> emit) async {
    emit(VerifyLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedOtp = prefs.getString('pending_otp') ?? '';
      if (storedOtp.isNotEmpty) {
        emit(VerifyOtpLoaded(storedOtp)); // Phát trạng thái OTP đã tải
      } else {
        emit(VerifyInitial()); // Không tìm thấy OTP
      }
    } catch (e) {
      emit(VerifyFailure('Lỗi khi tải OTP: $e'));
    }
  }

  Future<void> _onConfirmOTP(ConfirmOTPEvent event, Emitter<VerifyState> emit) async {
    emit(VerifyLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedOtp = prefs.getString('pending_otp') ?? '';
      final enteredOtp = event.otp;

      if (enteredOtp.isNotEmpty && enteredOtp == storedOtp) {
        if (fromRoute != 'forgot_password') {
          await FirebaseAuth.instance.currentUser?.reload();
          if (FirebaseAuth.instance.currentUser == null) {
            final String? storedPassword = prefs.getString('temp_password');
            if (storedPassword != null && storedPassword.isNotEmpty) {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: email,
                password: storedPassword,
              );
              await FirebaseAuth.instance.currentUser?.reload();
            }
          }
        }
        await prefs.remove('pending_otp');
        await prefs.remove('pending_email');
        await prefs.remove('temp_password');
        emit(VerifySuccess());
      } else {
        emit(VerifyFailure('OTP không hợp lệ'));
      }
    } catch (e) {
      emit(VerifyFailure('Lỗi khi xác thực OTP: $e'));
    }
  }

  Future<void> _onResendLink(ResendLinkEvent event, Emitter<VerifyState> emit) async {
    emit(VerifyLoading());
    try {
      await DynamicLinksHandler.sendSignInLink(email);
      emit(VerifyInitial());
    } catch (e) {
      emit(VerifyFailure('Lỗi khi gửi lại liên kết: $e'));
    }
  }
}

class ConfirmOTPEvent extends VerifyEvent {
  final String otp;
  ConfirmOTPEvent(this.otp);
}