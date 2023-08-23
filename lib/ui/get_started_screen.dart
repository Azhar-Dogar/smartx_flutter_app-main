import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/common/app_button.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/ui/auth/user-profile/user_profile_screen.dart';
import 'package:smartx_flutter_app/util/constants.dart';

class GetStartedScreen extends StatelessWidget {
  static const String route = '/get_started_screen_route';
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;

    return Scaffold(
      backgroundColor: Constants.colorSecondaryVariant,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              width: size.width,
              color: Constants.colorPrimary,
              child: Image.asset(
                'assets/vector.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20, bottom: 40, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Welcome to Stroll ',
                  style: TextStyle(
                      fontSize: 28,
                      fontFamily: Constants.workSansBold,
                      color: Constants.colorSecondary),
                ),
                const SizedBox(height: 10),
                const Text(
                  'A new standard for dog walking experiences For every doggy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: Constants.workSansRegular,
                      color: Constants.colorSecondary),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    height: 65,
                    width: size.width,
                    child: AppButton(
                        onClick: () => Get.toNamed(UserProfileScreen.route),
                        text: 'Get Started',
                        fontFamily: Constants.workSansRegular,
                        textColor: Constants.colorTextWhite,
                        borderRadius: 10.0,
                        fontSize: 16,
                        color: Constants.buttonColor)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
