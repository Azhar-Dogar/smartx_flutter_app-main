import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/helper/firebase_storage_helper.dart';
import 'package:smartx_flutter_app/helper/firestore_database_helper.dart';
import 'package:smartx_flutter_app/helper/shared_preference_helpert.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';

class AddPostController extends GetxController {
  String? groupId;

  AddPostController({this.groupId}) {
    getUser();
  }

  getUser() async {
    user = await SharedPreferenceHelper.instance.user;
  }

  UserModel? user;
  final textController = TextEditingController();
  Rx<XFile?> fileImage = Rx<XFile?>(null);

  final FirebaseStorageHelper _firebaseStorageHelper =
      FirebaseStorageHelper.instance();
  final FirestoreDatabaseHelper _firestoreDatabaseHelper =
      FirestoreDatabaseHelper.instance();

  Future<PostModel?> addPost() async {
    if (user == null) return null;

    try {
      String? url;
      if (fileImage.value != null) {
        url = await _firebaseStorageHelper
            .uploadImage(File(fileImage.value?.path ?? ''));
      }
      final post = PostModel(
          text: textController.text,
          username: '${user?.firstName} ${user?.lastName}',
          imagePath: url,
          userImage: user?.imagePath ?? '',
          created: DateTime.now(),
          groupId: groupId ?? '',
          likedUsers: [],
          userid: user?.id ?? '',
          id: '');
      final res = await _firestoreDatabaseHelper.addPost(post);
      if (res is PostModel) {
        textController.clear();
        fileImage(null);
      }
      return res;
    } catch (_) {
      return null;
    }
  }
}
