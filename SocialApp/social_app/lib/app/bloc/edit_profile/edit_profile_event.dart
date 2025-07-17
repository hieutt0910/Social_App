abstract class EditProfileEvent {}

class LoadEditProfileEvent extends EditProfileEvent {
  final String uid;
  LoadEditProfileEvent(this.uid);
}

class UpdateProfileEvent extends EditProfileEvent {
  final String uid;
  final String name;
  final String lastName;
  final String location;
  final String? imageUrl;
  final String? instagram;
  final String? twitter;
  final String? website;
  final String? terms;

  UpdateProfileEvent({
    required this.uid,
    required this.name,
    required this.lastName,
    required this.location,
    this.imageUrl,
    this.instagram,
    this.twitter,
    this.website,
    this.terms,
  });
}