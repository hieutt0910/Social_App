import 'package:bloc/bloc.dart';
import '../../../Data/model/user.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial()) {
    on<LoadEditProfileEvent>(_onLoadEditProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadEditProfile(LoadEditProfileEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoading());
    try {
      final user = await AppUser.getFromFirestore(event.uid);
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
      final user = await AppUser.getFromFirestore(event.uid);
      if (user != null) {
        await user.updateInFirestore(
          name: event.name.isNotEmpty ? event.name : null,
          lastName: event.lastName.isNotEmpty ? event.lastName : null,
          location: event.location.isNotEmpty ? event.location : null,
          imageUrl: event.imageUrl,
          instagram: event.instagram,
          twitter: event.twitter,
          website: event.website,
          terms: event.terms,
        );
        emit(EditProfileSuccess());
      } else {
        emit(EditProfileError('User not found'));
      }
    } catch (e) {
      emit(EditProfileError('Error updating profile: $e'));
    }
  }
}