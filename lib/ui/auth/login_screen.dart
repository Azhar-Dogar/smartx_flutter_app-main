import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/common/app_button.dart';
import 'package:smartx_flutter_app/common/app_text_field.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/helper/material_dialog_helper.dart';
import 'package:smartx_flutter_app/helper/snackbar_helper.dart';
import 'package:smartx_flutter_app/helper/snackbar_message.dart';
import 'package:smartx_flutter_app/ui/auth/login_controller.dart';
import 'package:smartx_flutter_app/ui/auth/password_reset_screen.dart';
import 'package:smartx_flutter_app/ui/main/main_screen.dart';
import 'package:smartx_flutter_app/util/constants.dart';

class LoginScreen extends StatelessWidget {
  static const String route = '/login_screen_route';
  LoginScreen({super.key});
  Future<void> _login(
      String userEmail, String password, BuildContext context) async {
    final controller = Get.find<LoginController>();
    MaterialDialogHelper dialogHelper = MaterialDialogHelper.instance();
    SnackbarHelper snackbarHelper = SnackbarHelper.instance;
    snackbarHelper.injectContext(context);
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog('Signing in....');
    final message = await controller.signIn(userEmail, password);
    dialogHelper.dismissProgress();
    if (message == null) {
      snackbarHelper.showSnackbar(
          snackbar: SnackbarMessage.error(message: 'Try Again'));
      return;
    }
    final mes = message;
    if (mes.isEmpty) {
      snackbarHelper.showSnackbar(
          snackbar: SnackbarMessage.success(message: "Login Successfully"));
    } else {
      snackbarHelper.showSnackbar(
          snackbar: SnackbarMessage.error(message: mes));
      return;
    }
    Get.offAllNamed(MainScreen.route);
  }

  final loginController = Get.find<LoginController>();
  Future<void> _googleSingIn(BuildContext context) async {
    final controller = Get.find<LoginController>();
    MaterialDialogHelper _dialogHelper = MaterialDialogHelper.instance();
    SnackbarHelper _snackbarHelper = SnackbarHelper.instance;
    _snackbarHelper.injectContext(context);
    _dialogHelper
      ..injectContext(context)
      ..showProgressDialog("Google sigining.....");
    final result = await controller.signInWithGoogle();
    _dialogHelper.dismissProgress();
    // if (result == null) {
    //   await Future.delayed(const Duration(milliseconds: 600));
    //   _dialogHelper
    //     ..injectContext(context)
    //     ..showMaterialDialogWithContent(
    //         MaterialDialogContent.networkError(), () => _googleSingIn(context));
    //   return;
    // }

    if (result is String && result.isNotEmpty) {
      _snackbarHelper.showSnackbar(
        snackbar: SnackbarMessage.error(message: result),
      );
      return;
    }
    if (result is String && result.isEmpty) {
      Get.offAllNamed(MainScreen.route);
      return;
    }
    Get.offAllNamed(MainScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

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
                GetX<LoginController>(builder: (_) {
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
                GetX<LoginController>(builder: (_){
                  return AppTextField(
                      hint: 'Password',
                      color: Constants.colorTextField,
                      radius: 10,
                      controller: controller.passwordController,
                      onChanged: (s) => controller.isPasswordError(''),
                      isObscure: loginController.isPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon((loginController.isPasswordVisible.value)
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          loginController.toggleIsPasswordVisible();
                        },
                      ),
                      textInputType: TextInputType.text,
                      isError: controller.isPasswordError.isNotEmpty);}
                ),
                GetX<LoginController>(builder: (_) {
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
                const SizedBox(
                  height: 15,
                ),
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
                          if (controller.emailController.text.isNotEmpty &&
                              controller.passwordController.text.isNotEmpty) {
                            _login(controller.emailController.text,
                                controller.passwordController.text, context);
                          }
                        },
                        text: 'Login',
                        fontFamily: Constants.workSansRegular,
                        textColor: Constants.colorTextWhite,
                        borderRadius: 10.0,
                        fontSize: 16,
                        color: Constants.buttonColor)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Forgot Password? ',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: Constants.workSansRegular,
                          color: Constants.colorPrimaryVariant),
                    ),
                    InkWell(
                      onTap: () => Get.toNamed(PasswordResetScreen.route),
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Constants.workSansMedium,
                            color: Constants.colorPrimaryVariant),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      color: Constants.colorSecondary,
                      height: 1,
                    ),
                    const Text(
                      ' or continue with ',
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
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => _googleSingIn(context),
                      child: socialIcon('assets/Google.png'),
                    ),
                    const SizedBox(width: 10,),
                    socialIcon("assets/apple_icon.png"),
                    const SizedBox(width: 10,),
                    socialIcon('assets/Facebook.png')
                  ],
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
  Widget socialIcon(String imagePath){
    return Card(
      elevation: 5,
      child: Container(
        height: 50,
        width: 50,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Constants.colorOnBackground,
            borderRadius: BorderRadius.circular(10)),
        child: Image.asset(imagePath),
      ),
    );
  }
}
