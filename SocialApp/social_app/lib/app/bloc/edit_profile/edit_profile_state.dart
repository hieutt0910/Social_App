import 'dart:io';

import '../../../data/model/user.dart';

enum EditProfileStatus { initial, loading, success, failure }

class EditProfileState {
  final EditProfileStatus status;
  final AppUser? user;
  final File? selectedImage;
  final String? error;

  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.user,
    this.selectedImage,
    this.error,
  });

  EditProfileState copyWith({
    EditProfileStatus? status,
    AppUser? user,
    File? selectedImage,
    String? error,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      selectedImage: selectedImage ?? this.selectedImage,
      error: error ?? this.error,
    );
  }
}