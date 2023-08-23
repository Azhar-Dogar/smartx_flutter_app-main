import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/common/app_button.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/ui/auth/login_screen.dart';
import 'package:smartx_flutter_app/ui/auth/sign-up/signup_screen.dart';
import 'package:smartx_flutter_app/util/constants.dart';

class WelcomeScreen extends StatelessWidget {
  static const String route = '/';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 30,left: 20,right: 20),
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/splashBg.png'), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 65,
                width: size.width,
                child: AppButton(
                    onClick: () => Get.toNamed(LoginScreen.route),

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
                  'Dont have an account? ',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: Constants.workSansRegular,
                      color: Constants.colorTextWhite),
                ),
                InkWell(
                  onTap: ()=> Get.toNamed(SignUpScreen.route),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: Constants.workSansMedium,
                        color: Constants.buttonColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
