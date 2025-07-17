
import 'dart:io';
import 'package:dio/dio.dart';

class CloudinaryService {
  final Dio _dio = Dio();
  final String cloudName = 'dejo6jhgk';
  final String uploadPreset = 'unsigned_preset_123';

  Future<String> uploadImage(File file) async {
    final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'upload_preset': uploadPreset,
    });

    final response = await _dio.post(url, data: formData);

    if (response.statusCode == 200) {
      return response.data['secure_url']; 
    } else {
      throw Exception('Upload thất bại: ${response.statusCode}');
    }
  }
}
