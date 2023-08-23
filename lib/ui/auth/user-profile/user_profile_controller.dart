import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/helper/shared_preference_helpert.dart';

import '../../../helper/firebase_storage_helper.dart';
import '../../../helper/firestore_database_helper.dart';

class UserProfileController extends GetxController {
  bool isFromStart;
  UserModel? user;

  UserProfileController({this.user, this.isFromStart = true}) {
    initData();
  }

  initData() async {
    firstNameController.text = user?.firstName ?? '';
    cityController.text = user?.city ?? '';
    bioController.text = user?.bio ?? '';
    countryController.text = user?.country ?? '';
    lastNameController.text = user?.lastName ?? '';
  }

  final countryController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bioController = TextEditingController();
  final cityController = TextEditingController();
  Rx<XFile?> fileImage = Rx<XFile?>(null);
  final FirebaseStorageHelper _firebaseStorageHelper =
      FirebaseStorageHelper.instance();
  final FirestoreDatabaseHelper _firestoreDatabaseHelper =
      FirestoreDatabaseHelper.instance();

  Future<String?> saveProfile() async {
    final user = await SharedPreferenceHelper.instance.user;
    if (user == null) return null;

    try {
      String? url;
      if (fileImage.value != null) {
        url = await _firebaseStorageHelper
            .uploadImage(File(fileImage.value?.path ?? ''));
      }
      final user2 = user.copyWith(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          imagePath: url ?? '',
          bio: bioController.text,
          country: countryController.text,
          city: cityController.text);
      await _firestoreDatabaseHelper.updateUser(user2);
      await SharedPreferenceHelper.instance.insertUser(user2);
      return '';
    } catch (_) {
      return null;
    }
  }

  Future<String?> editProfile() async {
    String? url;
    if (fileImage.value != null) {
      url = await _firebaseStorageHelper
          .uploadImage(File(fileImage.value?.path ?? ''));
    }
    final user2 = user!.copyWith(
        fcmToken: user?.fcmToken ?? '',
        email: user?.email ?? '',
        id: user?.id ?? '',
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        imagePath: url ?? user?.imagePath ?? '',
        bio: bioController.text,
        country: countryController.text,
        city: cityController.text);
    await _firestoreDatabaseHelper.updateUser(user2);
    try {

      await SharedPreferenceHelper.instance.insertUser(user2);
      return '';
    } catch (_) {
      return null;
    }
  }
}
