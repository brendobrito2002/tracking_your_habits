import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoRepository {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickFromCamera(String uid) async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
    );

    return _saveImage(image, uid);
  }

  Future<String?> pickFromGallery(String uid) async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    return _saveImage(image, uid);
  }

  Future<String?> _saveImage(XFile? image, String uid) async {
    if (image == null) return null;

    final directory = await getApplicationDocumentsDirectory();

    final extension = path.extension(image.path);
    final fileName = 'profile_photo_$uid$extension';
    final savedPath = path.join(directory.path, fileName);

    final file = await File(image.path).copy(savedPath);

    await savePhotoPath(uid, file.path);

    return file.path;
  }

  Future<void> savePhotoPath(String uid, String photoPath) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'profile_photo_path_$uid',
      photoPath,
    );
  }

  Future<String?> getPhotoPath(String uid) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(
      'profile_photo_path_$uid',
    );
  }

  Future<void> removePhoto(String uid) async {
    final prefs = await SharedPreferences.getInstance();

    final savedPath = prefs.getString(
      'profile_photo_path_$uid',
    );

    if (savedPath != null) {
      final file = File(savedPath);

      if (await file.exists()) {
        await file.delete();
      }
    }

    await prefs.remove(
      'profile_photo_path_$uid',
    );
  }
}