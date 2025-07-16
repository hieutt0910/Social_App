import 'package:bloc/bloc.dart';
import '../../../Domain/usecase/user/get_user.dart';
import 'user_profile_event.dart';
import 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserUseCase getUserUseCase;

  UserProfileBloc({required this.getUserUseCase}) : super(UserProfileInitial()) {
    on<LoadUserProfileEvent>(_onLoadUserProfile);
  }

  Future<void> _onLoadUserProfile(LoadUserProfileEvent event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      final user = await getUserUseCase.execute(event.uid);
      if (user != null) {
        emit(UserProfileLoaded(user));
      } else {
        emit(UserProfileError('User not found'));
      }
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }
}