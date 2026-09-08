import 'package:flutter/material.dart';

import '../repositories/photo_repository.dart';

class PhotoViewModel extends ChangeNotifier {
  final PhotoRepository _repository;

  String? _photoPath;

  PhotoViewModel(this._repository);

  String? get photoPath => _photoPath;

  Future<void> loadPhoto(String uid) async {
    _photoPath = null;

    final savedPath = await _repository.getPhotoPath(uid);

    if (savedPath != null) {
      _photoPath = savedPath;
    }

    notifyListeners();
  }

  Future<void> takePhoto(String uid) async {
    final path = await _repository.pickFromCamera(uid);

    if (path == null) return;

    _photoPath = path;
    notifyListeners();
  }

  Future<void> pickPhoto(String uid) async {
    final path = await _repository.pickFromGallery(uid);

    if (path == null) return;

    _photoPath = path;
    notifyListeners();
  }

  Future<void> removePhoto(String uid) async {
    await _repository.removePhoto(uid);

    _photoPath = null;
    notifyListeners();
  }
}