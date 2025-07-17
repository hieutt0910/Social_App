import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../Data/model/user.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final FirebaseAuth firebaseAuth;

  AccountBloc({required this.firebaseAuth}) : super(AccountInitial()) {
    on<LoadUserEvent>(_onLoadUser);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onLoadUser(LoadUserEvent event, Emitter<AccountState> emit) async {
    emit(AccountLoading());
    try {
      final user = await AppUser.getFromFirestore(event.uid);
      if (user != null) {
        emit(AccountLoaded(user));
      } else {
        emit(AccountError('User not found'));
      }
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AccountState> emit) async {
    try {
      await firebaseAuth.signOut();
      emit(AccountSignedOut());
    } catch (e) {
      emit(AccountError('Error signing out: $e'));
    }
  }
}