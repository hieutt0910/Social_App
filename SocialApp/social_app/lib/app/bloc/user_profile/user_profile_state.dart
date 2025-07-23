import '../../../data/model/collection.dart';
import '../../../data/model/user.dart';

abstract class UserProfileState {}

// Trạng thái đang tải
class UserProfileLoading extends UserProfileState {}

// Trạng thái tải thành công, chứa cả user và collections
class UserProfileLoadSuccess extends UserProfileState {
  final AppUser user;
  final List<Collection> collections;

  UserProfileLoadSuccess({required this.user, required this.collections});
}

// Trạng thái tải thất bại
class UserProfileLoadFailure extends UserProfileState {
  final String error;

  UserProfileLoadFailure(this.error);
}