import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  static const String _IMAGES = 'profile';
  static const String _IMAGES_POST = 'post';
  static const Duration _timeoutDuration = Duration(seconds: 120);
  static FirebaseStorageHelper? _instance;

  FirebaseStorageHelper._();

  static FirebaseStorageHelper instance() {
    _instance ??= FirebaseStorageHelper._();
    return _instance!;
  }

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  String get imageId =>
      DateTime.now().millisecondsSinceEpoch.round().toString();

  Reference get _imageUploadReference => _firebaseStorage.ref(_IMAGES);
  Reference get _imageUploadPostReference => _firebaseStorage.ref(_IMAGES_POST);

  Future<String?> uploadImage(File imageFile) async {
    final file = File(imageFile.path);
    try {
      final taskUpload = await _imageUploadReference
          .child(imageId)
          .putFile(file)
          .timeout(_timeoutDuration);
      return await taskUpload.ref.getDownloadURL();
    } catch (_) {
      return null;
    }
  }
  Future<String?> uploadPostImage(File imageFile) async {
    final file = File(imageFile.path);
    try {
      final taskUpload = await _imageUploadPostReference
          .child(imageId)
          .putFile(file)
          .timeout(_timeoutDuration);
      return await taskUpload.ref.getDownloadURL();
    } catch (_) {
      return null;
    }
  }
}
