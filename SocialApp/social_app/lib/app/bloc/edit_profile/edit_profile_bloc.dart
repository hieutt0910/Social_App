import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/data/model/user.dart';

import 'edit_profile_event.dart';
import 'edit_profile_state.dart';


class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(const EditProfileState()) {
    on<EditProfileDataRequested>(_onDataRequested);
    on<EditProfileImagePicked>(_onImagePicked);
    on<EditProfileChangesSaved>(_onChangesSaved);
  }

  Future<void> _onDataRequested(
      EditProfileDataRequested event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(status: EditProfileStatus.loading));
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) throw Exception("User not found");

      final appUser = await AppUser.getFromFirestore(firebaseUser.uid);
      if (appUser == null) throw Exception("Could not load user data");

      emit(state.copyWith(status: EditProfileStatus.initial, user: appUser));
    } catch (e) {
      emit(state.copyWith(status: EditProfileStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onImagePicked(
      EditProfileImagePicked event, Emitter<EditProfileState> emit) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      emit(state.copyWith(selectedImage: File(pickedFile.path)));
    }
  }

  Future<void> _onChangesSaved(
      EditProfileChangesSaved event, Emitter<EditProfileState> emit) async {
    if (state.user == null) return;
    emit(state.copyWith(status: EditProfileStatus.loading));

    try {
      String? base64Image;
      if (state.selectedImage != null) {
        final bytes = await state.selectedImage!.readAsBytes();
        base64Image = base64Encode(bytes);
      }

      String instagram = (event.data['instagram'] ?? '').trim();
      if (instagram.isNotEmpty && !instagram.startsWith('@')) {
        instagram = '@$instagram';
      }

      String twitter = (event.data['twitter'] ?? '').trim();
      if (twitter.isNotEmpty && !twitter.startsWith('@')) {
        twitter = '@$twitter';
      }

      String website = (event.data['website'] ?? '').trim();
      if (website.isNotEmpty && !website.startsWith('http')) {
        website = 'https://$website';
      }

      String terms = (event.data['terms'] ?? '').trim();
      if (terms.isNotEmpty && !terms.startsWith('http')) {
        terms = 'https://$terms';
      }
      // --- KẾT THÚC LOGIC CHUẨN HÓA ---

      await state.user!.updateInFirestore(
        name: event.data['name']!.trim(),
        lastName: event.data['lastName']!.trim(),
        location: event.data['location']!.trim(),
        imageUrl: base64Image, // Sẽ là null nếu không có ảnh mới
        instagram: instagram,
        twitter: twitter,
        website: website,
        terms: terms,
      );
      emit(state.copyWith(status: EditProfileStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditProfileStatus.failure, error: e.toString()));
    }
  }
}