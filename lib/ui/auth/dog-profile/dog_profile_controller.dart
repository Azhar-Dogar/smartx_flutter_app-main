import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/helper/firebase_storage_helper.dart';
import 'package:smartx_flutter_app/helper/firestore_database_helper.dart';
import 'package:smartx_flutter_app/util/functions.dart';

import '../../../helper/shared_preference_helpert.dart';
import '../../../models/dog_model.dart';
import '../../user-detail/user_detail_controller.dart';

class DogProfileController extends GetxController {
  bool isFromStart;

  DogProfileController({this.dogModel, this.isFromStart = true}) {
    if (dogModel != null) {
      genderController.text = dogModel!.gender;
      nameController.text = dogModel!.name;
      sizeController.text = dogModel!.size;
      isGoodWithKids(dogModel?.isGoodWithKids ?? false);
      isNeutered(dogModel?.isNeutered ?? false);
      isGoodWithDogs(dogModel?.isGoodWithDogs ?? false);
    }
  }

  DogModel? dogModel;
  final sizeController = TextEditingController();
  final genderController = TextEditingController();
  final nameController = TextEditingController();
  Rx<XFile?> fileImage = Rx<XFile?>(null);
  Rx<bool> isGoodWithKids = Rx<bool>(false);
  Rx<bool> isGoodWithDogs = Rx<bool>(false);
  Rx<bool> isNeutered = Rx<bool>(false);

  final FirebaseStorageHelper _firebaseStorageHelper =
      FirebaseStorageHelper.instance();
  final FirestoreDatabaseHelper _firestoreDatabaseHelper =
      FirestoreDatabaseHelper.instance();

  Future<DogModel?> saveDogProfile() async {
    final user = await SharedPreferenceHelper.instance.user;
    if (user == null) return null;

    try {
      String? url;
      if (fileImage.value != null) {
        url = await _firebaseStorageHelper
            .uploadImage(File(fileImage.value?.path ?? ''));
      }
      final dog = DogModel(
          userId: user.id,
          name: nameController.text,
          size: sizeController.text,
          imagePath: url,
          id: '-1',
          isGoodWithDogs: isGoodWithDogs.value,
          isGoodWithKids: isGoodWithKids.value,
          isNeutered: isNeutered.value,
          gender: genderController.text, isSelected: false);
      final res = await _firestoreDatabaseHelper.addDogProfile(dog);
      return res;
    } catch (_) {
      return null;
    }
  }

  Future<void> updateDogProfile(BuildContext context) async {
    final user = await SharedPreferenceHelper.instance.user;
    if (user == null) return;
    Functions.showLoaderDialog(context);
    final controller = Get.find<UserDetailController>();
    try {
      String? url;
      if (fileImage.value != null) {
        url = await _firebaseStorageHelper
            .uploadImage(File(fileImage.value?.path ?? ''));
      }
      final dog = DogModel(
          userId: user.id,
          name: nameController.text,
          size: sizeController.text,
          imagePath: url ?? dogModel?.imagePath,
          id: dogModel?.id ?? '-1',
          isGoodWithDogs: isGoodWithDogs.value,
          isGoodWithKids: isGoodWithKids.value,
          isNeutered: isNeutered.value,
          gender: genderController.text, isSelected: false);
      final res = await _firestoreDatabaseHelper.editDogProfile(dog);
      if(res is DogModel){
        controller.getUserDogs();
      Navigator.pop(context);
      Navigator.pop(context);
      Functions.showSnackBar(context, "Dog updated successfully");
      // Get.back();
    }else{
        Get.back();
        Functions.showSnackBar(context, "Something went wrong");
      }} catch (_) {
      return;
    }
  }
}

class SelectionModel {
  final String title;
  final bool isSelect;

  SelectionModel({required this.title, required this.isSelect});
}
