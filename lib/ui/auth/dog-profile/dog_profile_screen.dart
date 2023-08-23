import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/common/app_button.dart';
import 'package:smartx_flutter_app/common/app_text_field.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/helper/material_dialog_helper.dart';
import 'package:smartx_flutter_app/helper/snackbar_helper.dart';
import 'package:smartx_flutter_app/helper/snackbar_message.dart';
import 'package:smartx_flutter_app/ui/auth/dog-profile/dog_profile_controller.dart';
import 'package:smartx_flutter_app/ui/main/main_screen.dart';
import 'package:smartx_flutter_app/util/constants.dart';

class DogProfileScreen extends StatelessWidget {
  static const String route = '/dog_profile_screen_route';

  const DogProfileScreen({super.key});

  _addDog(BuildContext context) async {
    final controller = Get.find<DogProfileController>();
    if (controller.dogModel != null) return;

    MaterialDialogHelper dialogHelper = MaterialDialogHelper.instance();
    SnackbarHelper snackbarHelper = SnackbarHelper.instance;
    snackbarHelper.injectContext(context);
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog('Saving Dog Profile....');

    final res = await controller.saveDogProfile();
    dialogHelper.dismissProgress();
    if (res is DogModel) {
      snackbarHelper.showSnackbar(
          snackbar: SnackbarMessage.success(message: "Dog Added Successfully"));
      if (controller.isFromStart) {
        Get.offAllNamed(MainScreen.route);
      } else {
        Get.back(result: res);
      }
    } else {
      snackbarHelper.showSnackbar(
          snackbar: SnackbarMessage.error(message: "Something went wrong"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final controller = Get.find<DogProfileController>();

    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Constants.colorSecondaryVariant,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, bottom: 10, top: 20),
              child: Row(children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back,
                      color: Constants.colorPrimaryVariant, size: 30),
                ),
                const Text('Back',
                    style: TextStyle(
                        fontFamily: Constants.workSansRegular,
                        fontSize: 18,
                        color: Constants.colorPrimaryVariant)),
                const Spacer(),
              ]),
            ),
            Expanded(
                child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, bottom: 40, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    controller.dogModel == null
                        ? 'Add Dog Profile '
                        : 'Edit Dog Profile',
                    style: const TextStyle(
                        fontSize: 28,
                        fontFamily: Constants.workSansBold,
                        color: Constants.colorSecondary),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                      controller: controller.nameController,
                      hint: 'Name',
                      color: Constants.colorTextField,
                      radius: 10,
                      textInputType: TextInputType.emailAddress,
                      isError: false),
                  Container(
                    alignment: Alignment.center,
                    width: size.width,
                    height: size.height * 0.4,
                    decoration: BoxDecoration(
                        color: Constants.colorOnCard,
                        borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                      onTap: () async {
                        final XFile? pickedImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        controller.fileImage(pickedImage);
                      },
                      child: GetX<DogProfileController>(
                        builder: (_) {
                          return controller.fileImage.value != null
                              ? Image.file(
                                  File(controller.fileImage.value!.path),
                                  fit: BoxFit.cover)
                              : (controller.dogModel !=
                                          null &&
                                      controller
                                              .dogModel?.imagePath
                                              .toString() !=
                                          '')
                                  ? CachedNetworkImage(
                                      imageUrl: controller
                                              .dogModel?.imagePath ??
                                          '',
                                      placeholder: (context, url) =>
                                          const Center(
                                              child: CircularProgressIndicator
                                                  .adaptive()))
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                          Image.asset('assets/Image.png',
                                              width: 80),
                                          const SizedBox(height: 10),
                                          const Text('Choose Image',
                                              style: TextStyle(
                                                  color: Constants
                                                      .colorSecondaryVariant,
                                                  fontFamily: Constants
                                                      .workSansRegular))
                                        ]);
                        },
                      ),
                    ),
                  ),
                  PopupMenuButton(
                      enabled: true,
                      constraints: BoxConstraints(minWidth: size.width - 48),
                      position: PopupMenuPosition.over,
                      tooltip: '',
                      splashRadius: 0,
                      color: Constants.colorOnBackground,
                      offset: const Offset(0, 50),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      padding: const EdgeInsetsDirectional.only(end: 0),
                      onSelected: (String value) =>
                          controller.sizeController.text = value,
                      itemBuilder: (context) {
                        context.unfocus();
                        return ['Small size', 'Mid Size', 'Large size']
                            .map((String choice) => PopupMenuItem(
                                value: choice,
                                child: Text(
                                  choice,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      color: Constants.colorOnSurface),
                                )))
                            .toList();
                      },
                      child: AppTextField(
                          controller: controller.sizeController,
                          hint: 'Size',
                          onTap: () => context.unfocus(),
                          readOnly: true,
                          height: 60,
                          hintcolor: Constants.colorOnSurface,
                          radius: 10,
                          enable: false,
                          color: Constants.colorOnBackground,
                          textInputType: TextInputType.text,
                          suffixIcon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Constants.colorOnSurface,
                          ),
                          isError: false)),
                  PopupMenuButton(
                      enabled: true,
                      constraints: BoxConstraints(minWidth: size.width - 48),
                      position: PopupMenuPosition.over,
                      tooltip: '',
                      splashRadius: 0,
                      color: Constants.colorOnBackground,
                      offset: const Offset(0, 50),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      padding: const EdgeInsetsDirectional.only(end: 0),
                      onSelected: (String value) =>
                          controller.genderController.text = value,
                      itemBuilder: (context) {
                        context.unfocus();
                        return ['Male', 'Female']
                            .map((String choice) => PopupMenuItem(
                                value: choice,
                                child: Text(
                                  choice,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      color: Constants.colorOnSurface),
                                )))
                            .toList();
                      },
                      child: AppTextField(
                          controller: controller.genderController,
                          hint: 'Gender',
                          onTap: () => context.unfocus(),
                          readOnly: true,
                          height: 60,
                          hintcolor: Constants.colorOnSurface,
                          radius: 10,
                          enable: false,
                          color: Constants.colorOnBackground,
                          textInputType: TextInputType.text,
                          suffixIcon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Constants.colorOnSurface,
                          ),
                          isError: false)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        color: Constants.colorSecondary,
                        height: 1,
                      ),
                      const Text(
                        ' Select that applies ',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Constants.workSansMedium,
                            color: Constants.colorSecondary),
                      ),
                      Container(
                        width: 80,
                        color: Constants.colorSecondary,
                        height: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GetX<DogProfileController>(
                          builder: (_) {
                            return InkWell(
                              onTap: () => controller.isGoodWithDogs(
                                  !controller.isGoodWithDogs.value),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(
                                    right: 15, left: 15, top: 15, bottom: 15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Constants.colorPrimary),
                                    color: controller.isGoodWithDogs.value
                                        ? Constants.colorPrimary
                                        : Constants.colorOnBackground,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Text(
                                  'Good with Dogs',
                                  style: TextStyle(
                                      color: Constants.colorSecondary,
                                      fontFamily: Constants.workSansRegular),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: GetX<DogProfileController>(
                          builder: (_) {
                            return InkWell(
                              onTap: () => controller.isGoodWithKids(
                                  !controller.isGoodWithKids.value),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(
                                    right: 15, left: 15, top: 15, bottom: 15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Constants.colorPrimary),
                                    color: controller.isGoodWithKids.value
                                        ? Constants.colorPrimary
                                        : Constants.colorOnBackground,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Text(
                                  'Good with Kids',
                                  style: TextStyle(
                                      color: Constants.colorSecondary,
                                      fontFamily: Constants.workSansRegular),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  GetX<DogProfileController>(
                    builder: (_) {
                      return GestureDetector(
                        onTap: () =>
                            controller.isNeutered(!controller.isNeutered.value),
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width,
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          padding: const EdgeInsets.only(
                              right: 15, left: 15, top: 15, bottom: 15),
                          decoration: BoxDecoration(
                              border: Border.all(color: Constants.colorPrimary),
                              color: controller.isNeutered.value
                                  ? Constants.colorPrimary
                                  : Constants.colorOnBackground,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                            'Neutered',
                            style: TextStyle(
                                color: Constants.colorSecondary,
                                fontFamily: Constants.workSansRegular),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                      height: 65,
                      width: size.width,
                      child: AppButton(
                          onClick: () => _addDog(context),
                          text:
                              controller.dogModel == null ? 'Add Dog' : 'Saved',
                          fontFamily: Constants.workSansRegular,
                          textColor: Constants.colorTextWhite,
                          borderRadius: 10.0,
                          fontSize: 16,
                          color: Constants.buttonColor)),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
