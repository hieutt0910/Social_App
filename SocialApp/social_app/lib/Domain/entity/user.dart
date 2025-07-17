class AppUser {
  final String uid;
  final String email;
  final String name;
  final String lastName;
  final String location;
  final String? imageUrl;
  final String? instagram;
  final String? twitter;
  final String? website;
  final String? terms;

  AppUser({
    required this.uid,
    required this.email,
    this.name = 'Unknown',
    this.lastName = '',
    this.location = '',
    this.imageUrl,
    this.instagram,
    this.twitter,
    this.website,
    this.terms,
  });
}