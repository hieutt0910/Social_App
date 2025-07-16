import 'package:bloc/bloc.dart';
import '../../../Domain/usecase/user/get_user.dart';
import '../../../Domain/usecase/user/update_user.dart';

import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final GetUserUseCase getUserUseCase;
  final UpdateUserUseCase updateUserUseCase;

  EditProfileBloc({required this.getUserUseCase, required this.updateUserUseCase})
      : super(EditProfileInitial()) {
    on<LoadEditProfileEvent>(_onLoadEditProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadEditProfile(LoadEditProfileEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoading());
    try {
      final user = await getUserUseCase.execute(event.uid);
      if (user != null) {
        emit(EditProfileLoaded(user));
      } else {
        emit(EditProfileError('User not found'));
      }
    } catch (e) {
      emit(EditProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoading());
    try {
      final updates = <String, dynamic>{};
      if (event.name.isNotEmpty) updates['name'] = event.name;
      if (event.lastName.isNotEmpty) updates['lastName'] = event.lastName;
      if (event.location.isNotEmpty) updates['location'] = event.location;
      if (event.imageUrl != null) updates['imageUrl'] = event.imageUrl;
      if (event.instagram != null) updates['instagram'] = event.instagram;
      if (event.twitter != null) updates['twitter'] = event.twitter;
      if (event.website != null) updates['website'] = event.website;
      if (event.terms != null) updates['terms'] = event.terms;

      await updateUserUseCase.execute(event.uid, updates);
      emit(EditProfileSuccess());
    } catch (e) {
      emit(EditProfileError('Error updating profile: $e'));
    }
  }
}