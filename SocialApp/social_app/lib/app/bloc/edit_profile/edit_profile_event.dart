abstract class EditProfileEvent {}

// Yêu cầu tải dữ liệu ban đầu của người dùng
class EditProfileDataRequested extends EditProfileEvent {}

// Người dùng đã chọn một ảnh mới
class EditProfileImagePicked extends EditProfileEvent {}

// Người dùng nhấn nút lưu thay đổi, gửi kèm tất cả dữ liệu từ form
class EditProfileChangesSaved extends EditProfileEvent {
  final Map<String, String> data;

  EditProfileChangesSaved(this.data);
}