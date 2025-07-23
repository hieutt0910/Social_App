import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/data/model/user.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountLoading()) {
    on<AccountDataRequested>(_onAccountDataRequested);
    on<AccountSignedOut>(_onAccountSignedOut);
  }

  Future<void> _onAccountDataRequested(
      AccountDataRequested event,
      Emitter<AccountState> emit,
      ) async {
    emit(AccountLoading());
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        emit(AccountLoadFailure("User not logged in."));
        return;
      }
      final appUser = await AppUser.getFromFirestore(firebaseUser.uid);
      if (appUser != null) {
        emit(AccountLoadSuccess(appUser));
      } else {
        emit(AccountLoadFailure("Could not load user profile."));
      }
    } catch (e) {
      emit(AccountLoadFailure(e.toString()));
    }
  }

  Future<void> _onAccountSignedOut(
      AccountSignedOut event,
      Emitter<AccountState> emit,
      ) async {
    try {
      await FirebaseAuth.instance.signOut();
      emit(AccountSignOutSuccess());
    } catch (e) {
      emit(AccountLoadFailure("Failed to sign out: ${e.toString()}"));
    }
  }
}