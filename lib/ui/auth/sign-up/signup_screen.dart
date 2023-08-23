import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/common/app_button.dart';
import 'package:smartx_flutter_app/common/app_text_field.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/helper/material_dialog_helper.dart';
import 'package:smartx_flutter_app/helper/snackbar_helper.dart';
import 'package:smartx_flutter_app/helper/snackbar_message.dart';
import 'package:smartx_flutter_app/ui/auth/sign-up/signup_controller.dart';
import 'package:smartx_flutter_app/ui/auth/user-profile/user_profile_screen.dart';
import 'package:smartx_flutter_app/ui/get_started_screen.dart';
import 'package:smartx_flutter_app/ui/main/main_screen.dart';
import 'package:smartx_flutter_app/util/constants.dart';

class SignUpScreen extends StatelessWidget {
  static const String route = '/signup_screen_route';
  const SignUpScreen({super.key});
  Future<void> _signUp(
      String userEmail, String password, BuildContext context) async {
    final controller = Get.find<SignUpController>();
    MaterialDialogHelper dialogHelper = MaterialDialogHelper.instance();
    SnackbarHelper snackbarHelper = SnackbarHelper.instance;
    snackbarHelper.injectContext(context);
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog('creating....');
    final message = await controller.createAccount(userEmail, password);
    dialogHelper.dismissProgress();
    if (message == null) {
      snackbarHelper.showSnackbar(
          snackbar: SnackbarMessage.error(message: 'Try Again'));
      return;
    }
    final mes = message;
    if (mes.isEmpty) {
      snackbarHelper.showSnackbar(
          snackbar: SnackbarMessage.success(message: "Signup Successfully"));
    } else {
      snackbarHelper.showSnackbar(
          snackbar: SnackbarMessage.error(message: mes));
      return;
    }
    Get.offAllNamed(GetStartedScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignUpController>();

    final size = context.screenSize;
    return Scaffold(
      backgroundColor: Constants.colorBackground,
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(height: 30),
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
          child: Row(children: [
            InkWell(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.arrow_back,
                color: Constants.colorPrimaryVariant,
                size: 30,
              ),
            ),
            const Text('Back',
                style: TextStyle(
                    fontFamily: Constants.workSansRegular,
                    fontSize: 18,
                    color: Constants.colorPrimaryVariant))
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
            child: Column(
              children: [
                SizedBox(width: 250, child: Image.asset('assets/logo.png')),
                const SizedBox(height: 20),
                AppTextField(
                    hint: 'Email',
                    color: Constants.colorTextField,
                    radius: 10,
                    textInputType: TextInputType.emailAddress,
                    controller: controller.emailController,
                    onChanged: (s) => controller.isEmailError(''),
                    isError: controller.isEmailError.isNotEmpty),
                GetX<SignUpController>(builder: (_) {
                  if (controller.isEmailError.value.isNotEmpty) {
                    return Align(
                        alignment: Alignment.centerRight,
                        child: Text(controller.isEmailError.value,
                            style: const TextStyle(
                                fontFamily: Constants.workSansRegular,
                                fontSize: 11,
                                color: Constants.colorError)));
                  }
                  return const SizedBox();
                }),
                GetX<SignUpController>(
                  builder: (_){ return AppTextField(
                      hint: 'Password',
                      color: Constants.colorTextField,
                      radius: 10,
                      controller: controller.passwordController,
                      onChanged: (s) => controller.isPasswordError(''),
                      textInputType: TextInputType.visiblePassword,
                      isObscure: controller.isPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon((controller.isPasswordVisible.value)
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          // controller.changeVisibility();
                          controller.togglePasswordVisible();
                        },
                      ),
                      isError: controller.isPasswordError.isNotEmpty);}
                ),
                GetX<SignUpController>(builder: (_) {
                  if (controller.isPasswordError.value.isNotEmpty) {
                    return Align(
                        alignment: Alignment.centerRight,
                        child: Text(controller.isPasswordError.value,
                            style: const TextStyle(
                                fontFamily: Constants.workSansRegular,
                                fontSize: 11,
                                color: Constants.colorError)));
                  }
                  return const SizedBox();
                }),
                GetX<SignUpController>(
                  builder:(_)=> AppTextField(
                      hint: 'Confirm Password',
                      color: Constants.colorTextField,
                      radius: 10,
                      controller: controller.cPasswordController,
                      onChanged: (s) => controller.isCPasswordError(''),
                      textInputType: TextInputType.visiblePassword,
                      isObscure: controller.isPasswordVisible2.value,
                      suffixIcon: IconButton(
                        icon: Icon((controller.isPasswordVisible2.value)
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          // controller.changeVisibility();
                          controller.togglePasswordVisible2();
                        },
                      ),
                      isError: controller.isCPasswordError.isNotEmpty),
                ),
                GetX<SignUpController>(builder: (_) {
                  if (controller.isCPasswordError.value.isNotEmpty) {
                    return Align(
                        alignment: Alignment.centerRight,
                        child: Text(controller.isCPasswordError.value,
                            style: const TextStyle(
                                fontFamily: Constants.workSansRegular,
                                fontSize: 11,
                                color: Constants.colorError)));
                  }
                  return const SizedBox();
                }),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GetX<SignUpController>(
                      builder: (_) {
                        return Theme(
                          data: ThemeData(
                              unselectedWidgetColor:
                                  Constants.colorPrimaryVariant),
                          child: Checkbox(
                              visualDensity: VisualDensity.compact,
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Constants.colorPrimaryVariant),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              value: controller.isTerms.value,
                              onChanged: (s) {
                                controller.toggleIsTermsCheck();
                              }),
                        );
                      },
                    ),
                    const Text(
                      'I agree with the ',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: Constants.workSansRegular,
                          color: Constants.colorTextBlack),
                    ),
                    const Text(
                      'terms & conditions',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: Constants.workSansMedium,
                          color: Constants.colorPrimaryVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                    height: 65,
                    width: size.width,
                    child: AppButton(
                        onClick: () {
                          FocusScope.of(context).unfocus();

                          if (controller.emailController.text.isEmpty) {
                            controller.isEmailError('*email is required');
                          }
                          if (controller.passwordController.text.isEmpty) {
                            controller.isPasswordError('*password is required');
                          }
                          if (controller.passwordController.text !=
                              controller.cPasswordController.text) {
                            controller
                                .isCPasswordError('*password does not match');
                            return;
                          }
                          if (!controller.isTerms.value) {
                            SnackbarHelper snackbarHelper =
                                SnackbarHelper.instance;
                            snackbarHelper.injectContext(context);
                            snackbarHelper.showSnackbar(
                                snackbar: SnackbarMessage.error(
                                    message: 'Please check terms'));
                            return;
                          }

                          if (controller.emailController.text.isNotEmpty &&
                              controller.passwordController.text.isNotEmpty) {
                            _signUp(controller.emailController.text,
                                controller.passwordController.text, context);
                          }
                        },
                        text: 'Sign up',
                        fontFamily: Constants.workSansRegular,
                        textColor: Constants.colorTextWhite,
                        borderRadius: 10.0,
                        fontSize: 16,
                        color: Constants.colorOnSurface)),
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
                      ' or signup with ',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Constants.colorOnBackground,
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.asset('assets/Google.png'),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(left: 15, top: 20),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Constants.colorOnBackground,
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.asset('assets/Facebook.png'),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
