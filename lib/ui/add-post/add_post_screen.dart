import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartx_flutter_app/common/app_text_field.dart';
import 'package:smartx_flutter_app/helper/material_dialog_helper.dart';
import 'package:smartx_flutter_app/helper/snackbar_helper.dart';
import 'package:smartx_flutter_app/helper/snackbar_message.dart';
import 'package:smartx_flutter_app/models/achievement_model.dart';
import 'package:smartx_flutter_app/ui/add-post/add_post_controller.dart';
import 'package:smartx_flutter_app/ui/map-walk/map_walk_controller.dart';
import 'package:smartx_flutter_app/util/constants.dart';

import '../../models/post_model.dart';

class AddPostScreen extends StatelessWidget {
  static const String route = '/add_post_screen_route';

  const AddPostScreen({super.key});

  _addPost(BuildContext context, args) async {
    print(args);
    print("this is srgument");
    final controller = Get.find<AddPostController>();
    MaterialDialogHelper dialogHelper = MaterialDialogHelper.instance();
    SnackbarHelper snackbarHelper = SnackbarHelper.instance;
    snackbarHelper.injectContext(context);
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog('creating post....');

    final res = await controller.addPost(args ?? "");
    dialogHelper.dismissProgress();
    if (res is PostModel) {
      snackbarHelper.showSnackbar(
          snackbar:
          SnackbarMessage.success(message: "Post Added Successfully"));

      Get.back(result: res);
    } else {
      snackbarHelper.showSnackbar(
          snackbar: SnackbarMessage.error(message: "Something went wrong"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddPostController());
    final mapWalkController = Get.put(MapWalkController());
    final args = Get.arguments;
    print(args);
    print("args");
    return GetX<AddPostController>(builder: (DisposableInterface con) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Constants.colorSecondary,
            // titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: GestureDetector(
                onTap: () => Get.back(),
                child: const Row(children: [
                  Icon(
                    Icons.arrow_back,
                    color: Constants.colorOnBackground,
                  ),
                  Text('Back',
                      style: TextStyle(
                          fontFamily: Constants.workSansSemibold,
                          color: Constants.colorOnBackground,
                          fontSize: 16))
                ])),
            actions: [
              GestureDetector(
                  onTap: () async {
                    await _addPost(context, args);
                    await controller.updateUser();
                    if (controller.user.value!.userPosts! >= 20) {
                      List<AchievementModel> tempModel = mapWalkController.achievements
                          .where((p0) => p0.title == "20 posts").toList();
                      if (tempModel.isEmpty) {
                        mapWalkController.addAchievement("20 posts","You have make 20 posts",DateTime.now().millisecondsSinceEpoch,1);
                      }else{
                        if(controller.user.value!.userPosts! % 20 == 0){
                          mapWalkController.updateAchievement(tempModel.first.id, tempModel.first.count + 1);
                          mapWalkController.getAchievement();
                        }}
                    }
                  },
                  child: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text('POST',
                          style: TextStyle(
                              fontFamily: Constants.workSansSemibold,
                              color: Constants.colorOnBackground))))
            ]),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding:
                      const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                      child: Row(children: [
                        Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration:
                            const BoxDecoration(shape: BoxShape.circle),
                            child: (controller.user.value?.imagePath
                                .toString() !=
                                '' &&
                                controller.user.value?.imagePath != null)
                                ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                  controller.user.value?.imagePath ?? ""),
                              radius: 25,
                            )
                                : Image.asset('assets/4.png', height: 50)),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  controller.user.value?.firstName ??
                                      'Stella Andrew',
                                  style: const TextStyle(
                                      fontFamily: Constants.workSansMedium,
                                      color: Constants.colorSecondary))
                            ])
                      ])),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppTextField(
                          hint: 'Type here....',
                          controller: controller.textController,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          isError: false,
                          hasBorder: false)),
                  const SizedBox(height: 40),
                  controller.fileImage.value != null
                      ? Image.file(File(controller.fileImage.value!.path))
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final XFile? pickedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          controller.fileImage(pickedImage);
                          print("path");
                          print(controller.fileImage.value?.path);
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/attachment.png',
                              width: 20,
                              color: Constants.colorSecondary,
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'Attach Media',
                              style: TextStyle(
                                fontFamily: Constants.workSansMedium,
                                color: Constants.colorSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () async {
                          final XFile? pickedImage = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                          controller.fileImage(pickedImage);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.camera_alt_outlined,
                              color: Constants.colorSecondary,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Take Photo',
                              style: TextStyle(
                                fontFamily: Constants.workSansMedium,
                                color: Constants.colorSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}