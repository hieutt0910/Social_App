import 'package:bloc/bloc.dart';
import '../../../Data/model/user.dart';
import 'user_profile_event.dart';
import 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(UserProfileInitial()) {
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<ChangeTabEvent>(_onChangeTab);
  }

  Future<void> _onLoadUserProfile(LoadUserProfileEvent event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      final user = await AppUser.getFromFirestore(event.uid);
      if (user != null) {
        emit(UserProfileLoaded(user));
      } else {
        emit(UserProfileError('User not found'));
      }
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  void _onChangeTab(ChangeTabEvent event, Emitter<UserProfileState> emit) {
    if (state is UserProfileLoaded) {
      final currentState = state as UserProfileLoaded;
      emit(currentState.copyWith(selectedTab: event.tabIndex));
    }
  }
}