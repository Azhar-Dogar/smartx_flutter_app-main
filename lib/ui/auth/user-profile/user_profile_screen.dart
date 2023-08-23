import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartx_flutter_app/common/app_button.dart';
import 'package:smartx_flutter_app/common/app_text_field.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/helper/material_dialog_helper.dart';
import 'package:smartx_flutter_app/helper/snackbar_helper.dart';
import 'package:smartx_flutter_app/helper/snackbar_message.dart';
import 'package:smartx_flutter_app/ui/auth/dog-profile/dog_profile_screen.dart';
import 'package:smartx_flutter_app/ui/auth/user-profile/user_profile_controller.dart';
import 'package:smartx_flutter_app/util/constants.dart';

class UserProfileScreen extends StatelessWidget {
  static const String route = '/user_profile_screen_route';

  const UserProfileScreen({super.key});

  _saveProfile(BuildContext context) async {
    final controller = Get.find<UserProfileController>();
    MaterialDialogHelper dialogHelper = MaterialDialogHelper.instance();
    SnackbarHelper snackbarHelper = SnackbarHelper.instance;
    snackbarHelper.injectContext(context);
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog('saving profile....');

    final res = await controller.saveProfile();
    dialogHelper.dismissProgress();
    if (res is String) {
      snackbarHelper.showSnackbar(
          snackbar:
              SnackbarMessage.success(message: "Profile Saved Successfully"));
      Get.toNamed(DogProfileScreen.route);
    } else {
      snackbarHelper.showSnackbar(
          snackbar: SnackbarMessage.error(message: "Something went wrong"));
    }
  }

  _editProfile(BuildContext context) async {
    final controller = Get.find<UserProfileController>();
    MaterialDialogHelper dialogHelper = MaterialDialogHelper.instance();
    SnackbarHelper snackbarHelper = SnackbarHelper.instance;
    snackbarHelper.injectContext(context);
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog('updating profile....');

    final res = await controller.editProfile();
    dialogHelper.dismissProgress();
    if (res is String) {
      snackbarHelper.showSnackbar(
          snackbar:
              SnackbarMessage.success(message: "Profile Updated Successfully"));
      if (controller.isFromStart) {
        Get.toNamed(DogProfileScreen.route);
      }
    } else {
      snackbarHelper.showSnackbar(
          snackbar: SnackbarMessage.error(message: "Something went wrong"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final controller = Get.find<UserProfileController>();

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
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'User Profile ',
                    style: TextStyle(
                        fontSize: 28,
                        fontFamily: Constants.workSansBold,
                        color: Constants.colorSecondary),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      controller.user != null
                          ? 'Edit Your Profile'
                          : 'Create your profile for an enhanced app experience',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: Constants.workSansRegular,
                          color: Constants.colorSecondary),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    width: size.width,
                    height: size.height * 0.4,
                    color: Constants.colorOnCard,
                    child: InkWell(
                      onTap: () async {
                        final XFile? pickedImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        controller.fileImage(pickedImage);
                      },
                      child: GetX<UserProfileController>(
                        builder: (_) {
                          return controller.fileImage.value != null
                              ? Image.file(
                                  File(controller.fileImage.value!.path),
                                  fit: BoxFit.cover,
                                )
                              : (controller.user != null &&
                                      controller.user?.imagePath.toString() !=
                                          '')
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          controller.user?.imagePath ?? '',
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
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, bottom: 40, top: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                  hint: 'First Name',
                                  controller: controller.firstNameController,
                                  color: Constants.colorTextField,
                                  radius: 10,
                                  textInputType: TextInputType.emailAddress,
                                  isError: false),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AppTextField(
                                  hint: 'Last Name',
                                  controller: controller.lastNameController,
                                  color: Constants.colorTextField,
                                  radius: 10,
                                  textInputType: TextInputType.emailAddress,
                                  isError: false),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            context.unfocus();
                            showCountryPicker(
                                context: context,
                                countryListTheme: CountryListThemeData(
                                  flagSize: 25,
                                  backgroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                      fontSize: 16, color: Colors.blueGrey),
                                  bottomSheetHeight: 500,
                                  // Optional. Country list modal height
                                  //Optional. Sets the border radius for the bottomsheet.
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  ),
                                  //Optional. Styles the search field.
                                  inputDecoration: InputDecoration(
                                    labelText: 'Search',
                                    hintText: 'Start typing to search',
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: const Color(0xFF8C98A8)
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                ),
                                onSelect: (Country country) {
                                  controller.countryController.text =
                                      country.displayNameNoCountryCode;
                                });
                          },
                          child: AppTextField(
                              controller: controller.countryController,
                              hint: 'Country',
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
                              isError: false),
                        ),
                        AppTextField(
                            hint: 'City',
                            controller: controller.cityController,
                            color: Constants.colorTextField,
                            radius: 10,
                            textInputType: TextInputType.text,
                            isError: false),
                        AppTextField(
                            hint: 'Bio',
                            controller: controller.bioController,
                            color: Constants.colorTextField,
                            height: 100,
                            maxLines: 10,
                            minLines: 5,
                            radius: 10,
                            textInputType: TextInputType.emailAddress,
                            isError: false),
                        SizedBox(
                            height: 65,
                            width: size.width,
                            child: AppButton(
                                onClick: () {
                                  context.unfocus();
                                  if (controller.user == null) {
                                    _saveProfile(context);
                                  } else {
                                    _editProfile(context);
                                  }
                                },
                                text: 'Save',
                                fontFamily: Constants.workSansRegular,
                                textColor: Constants.colorTextWhite,
                                borderRadius: 10.0,
                                fontSize: 16,
                                color: Constants.buttonColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
