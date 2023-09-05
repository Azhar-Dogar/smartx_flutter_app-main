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
    user.value = await SharedPreferenceHelper.instance.user;
    update();
    print("this is user");
    print(user.value?.firstName);
    print(user.value?.lastName);
    print(user.value?.imagePath);
  }

  Rx<UserModel?> user = Rx<UserModel?>(null);
  final textController = TextEditingController();
  Rx<XFile?> fileImage = Rx<XFile?>(null);

  final FirebaseStorageHelper _firebaseStorageHelper =
      FirebaseStorageHelper.instance();
  final FirestoreDatabaseHelper _firestoreDatabaseHelper =
      FirestoreDatabaseHelper.instance();

  Future<PostModel?> addPost(String groupId) async {
    if (user == null) return null;

    try {
      String? url;
      if (fileImage.value != null) {
        url = await _firebaseStorageHelper
            .uploadImage(File(fileImage.value!.path));
        print("this is image url");
        print(url);
      }
      final post = PostModel(
          text: textController.text,
          username: '${user.value?.firstName} ${user.value?.lastName}',
          imagePath: url,
          userImage: user.value?.imagePath ?? '',
          created: DateTime.now(),
          groupId: groupId ?? '',
          likedUsers: [],
          userid: user.value?.id ?? '',
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
