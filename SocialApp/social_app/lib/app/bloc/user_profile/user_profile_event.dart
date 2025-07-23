abstract class UserProfileEvent {}

// Sự kiện yêu cầu tải dữ liệu (thông tin user và collections)
class UserProfileDataRequested extends UserProfileEvent {
  final String userId;

  UserProfileDataRequested(this.userId);
}