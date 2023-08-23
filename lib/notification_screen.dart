import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/util/constants.dart';

class NotificationScreen extends StatelessWidget {
  static const String route = '/notification_screen_route';
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;

    return Scaffold(
      backgroundColor: Constants.colorSecondaryVariant,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.colorSecondary,
        // titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: ()=> Get.back(),
          child: const Row(
            children: [
              Icon(
                Icons.arrow_back,
                color: Constants.colorOnBackground,
              ),
              Text(
                'Back',
                style: TextStyle(
                    fontFamily: Constants.workSansRegular,
                    color: Constants.colorOnBackground,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          for (var i=0;i<=4;i++)
          notificationItem(false),
          notificationItem(true),
          notificationItem(true),
        ],
      ),
    );
  }
  Widget notificationItem(bool isRead){
    return Column(
      children: [
        Container(
          color: (isRead)?Colors.white:Constants.unreadNotification.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 16),
            child: Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Image.asset(
                      'assets/dummy.png',
                      height: 40,
                    )),
                const Text('Hannah Johnson',
                    style: TextStyle(
                        fontFamily: Constants.workSansMedium,
                        color: Constants.colorSecondary)),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'Liked your post',
                  style: TextStyle(
                      fontSize: 11,
                      fontFamily: Constants.workSansLight,
                      color: Constants.colorSecondary),
                ),
                const Spacer(),
                const Text(
                  '3 hrs ago',
                  style: TextStyle(fontFamily: Constants.workSansRegular,fontSize: 9),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 2,)
      ],
    );
  }
}
