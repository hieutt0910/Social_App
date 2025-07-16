import 'dart:convert';
import 'package:flutter/material.dart';

class ImageUtils {
  // Kiểm tra xem chuỗi có phải là Base64 hợp lệ
  static bool isBase64(String? str) {
    if (str == null || str.isEmpty) return false;
    try {
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Lấy ImageProvider cho ảnh đại diện
  static ImageProvider getImageProvider(String? imageUrl, {String defaultAsset = 'assets/images/avatar.jpg'}) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return AssetImage(defaultAsset);
    }
    if (isBase64(imageUrl)) {
      return MemoryImage(base64Decode(imageUrl));
    }
    return NetworkImage(imageUrl);
  }
}