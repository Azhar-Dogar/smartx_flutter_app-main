import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/common/app_button.dart';
import 'package:smartx_flutter_app/common/app_text_field.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/ui/auth/password_reset_controller.dart';
import 'package:smartx_flutter_app/util/constants.dart';
import 'package:smartx_flutter_app/util/functions.dart';
import 'package:utility_extensions/utility_extensions.dart';

class PasswordResetScreen extends StatelessWidget {
  static const String route = '/password_reset_screen_route';
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PasswordResetController>();

    final size = context.screenSize;
    return Scaffold(
      backgroundColor: Constants.colorBackground,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
             Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
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
                  padding: const EdgeInsets.only(top: 120, right: 20, left: 20),
                  child: GetX<PasswordResetController>(builder: (_) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 250, child: Image.asset('assets/logo.png')),
                        const SizedBox(height: 20),
                        Text(
                          controller.isEmailSent.value
                              ? 'If you haven’t got the email in you inbox please check the spam folder'
                              : 'Enter you registered email address below, we will send you password reset link via email ',
                        textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14,
                              fontFamily: Constants.workSansMedium,
                              color: Constants.colorSecondary),
                        ),
                       const SizedBox(height: 20),
                        controller.isEmailSent.value
                            ? const SizedBox()
                            : AppTextField(
                                hint: 'Email',
                                color: Constants.colorTextField,
                                radius: 10,
                                textInputAction: TextInputAction.done,
                                textInputType: TextInputType.emailAddress,
                                controller: controller.emailController,
                                onChanged: (s) => controller.isEmailError(''),
                                isError: controller.isEmailError.isNotEmpty),
                        GetX<PasswordResetController>(builder: (_) {
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
                        const SizedBox(height: 15),
                        SizedBox(
                            height: 65,
                            width: size.width,
                            child: AppButton(
                                onClick: () {
                                  if(controller.emailController.text.isValidEmail){
                                    controller.isEmailSent(
                                        !controller.isEmailSent.value);
                                  }else{
                                    Functions.showToast(context, "Please enter a valid email address");
                                  }

                                },
                                text: controller.isEmailSent.value
                                    ? 'Resend'
                                    : 'Send',
                                fontFamily: Constants.workSansRegular,
                                textColor: Constants.colorTextWhite,
                                borderRadius: 10.0,
                                fontSize: 16,
                                color: Constants.buttonColor)),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.isEmailSent.value
                                  ? 'Entered the wrong email?'
                                  : 'Haven’t received email? ',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: Constants.workSansRegular,
                                  color: Constants.colorPrimaryVariant),
                            ),
                            InkWell(
                              onTap: (){
                                if(controller.isEmailSent.value){
                                   controller.isEmailSent(
                                      !controller.isEmailSent.value);
                                }
                              },
                              child: Text(
                                controller.isEmailSent.value
                                    ? 'Change'
                                    : 'Resend',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: Constants.workSansMedium,
                                    color: Constants.colorPrimaryVariant),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    );
                  })),
            )
          ]),
    );
  }
}
