import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signin_event.dart';
import 'signin_state.dart';
import '../../../Data/Repositories/dynamic_link_handler.dart';
import '../../../Data/model/user.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
  }

  Future<void> _onSignInWithEmail(
      SignInWithEmailEvent event, Emitter<SignInState> emit) async {
    if (state is SignInLoading) return;
    emit(SignInLoading());

    try {
      if (!event.email.contains('@')) {
        emit(const SignInFailure('Vui lòng nhập địa chỉ email hợp lệ'));
        return;
      }

      if (event.password.isEmpty) {
        emit(const SignInFailure('Vui lòng nhập mật khẩu'));
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pending_email', event.email);
      await prefs.setString('temp_password', event.password);

      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: event.email, password: event.password);

      if (userCredential.user != null) {
        final appUser = AppUser(
          uid: userCredential.user!.uid,
          email: event.email,
        );
        await appUser.saveToFirestore();
      }

      await DynamicLinksHandler.sendSignInLink(event.email);
      emit(SignInSuccess());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Không tìm thấy người dùng với email này.';
          break;
        case 'wrong-password':
          errorMessage = 'Mật khẩu không đúng.';
          break;
        default:
          errorMessage = 'Lỗi: ${e.message}';
      }
      emit(SignInFailure(errorMessage));
    } catch (e) {
      emit(SignInFailure('Lỗi: $e'));
    }
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogleEvent event, Emitter<SignInState> emit) async {
    if (state is SignInLoading) return;
    emit(SignInLoading());

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        emit(const SignInFailure('Đăng nhập bằng Google đã bị hủy'));
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final appUser = AppUser(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? 'Unknown',
          imageUrl: user.photoURL,
        );
        await appUser.saveToFirestore();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pending_email', user.email ?? '');

        await DynamicLinksHandler.sendSignInLink(user.email ?? '');
        emit(SignInSuccess());
      } else {
        emit(const SignInFailure('Đăng nhập bằng Google thất bại'));
      }
    } catch (e) {
      emit(SignInFailure('Lỗi khi đăng nhập bằng Google: $e'));
    }
  }
}