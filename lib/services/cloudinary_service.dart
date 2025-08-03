import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;


Future<String?> uploadImageToCloudinary(XFile imageFile) async {
  const cloudName = 'dk6heghvz';        // ← Thay bằng tên của bạn
  const uploadPreset = 'fitjourney_unsigned';  // ← Thay bằng preset của bạn

  final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

  try {
    final request = http.MultipartRequest('POST', url);
    request.fields['upload_preset'] = uploadPreset;

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imageFile.path,
    ));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      return data['secure_url'];
    } else {
      print('[Cloudinary] Upload failed: $responseBody');
      return null;
    }
  } catch (e) {
    print('[Cloudinary] Exception: $e');
    return null;
  }
}
