import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/helper/firebase_auth_helper.dart';
import 'package:smartx_flutter_app/helper/firestore_database_helper.dart';
import 'package:smartx_flutter_app/helper/shared_preference_helpert.dart';
import 'package:smartx_flutter_app/ui/auth/reset_password.dart';
import 'package:smartx_flutter_app/ui/find-and-view/find_and_view_screen.dart';
import 'package:smartx_flutter_app/ui/main/main_screen_controller.dart';
import 'package:smartx_flutter_app/ui/user-detail/user_detail_screen.dart';
import 'package:smartx_flutter_app/ui/welcome_screen.dart';
import 'package:smartx_flutter_app/util/constants.dart';

import '../../../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  static const String key_title = '/profile_screen_title';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final controller = Get.find<MainScreenController>();
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("user")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    UserModel user =
                    UserModel.fromJson(snapshot.data!.data()!);
                    return Column(
                      children: [
                        user.imagePath.toString() == ''
                            ? Image.asset('assets/3.png', width: 100)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                    imageUrl: user.imagePath ?? '',
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100),
                              ),
                        const SizedBox(height: 20),
                        Text(
                          user.firstName ?? 'David Johnson',
                          style: const TextStyle(
                              fontSize: 22,
                              fontFamily: Constants.workSansBold,
                              color: Constants.colorSecondary),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(UserDetailScreen.route,
                              arguments: MapEntry(true, user)),
                          child: const Text(
                            'View Profile',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: Constants.workSansRegular,
                                color: Constants.colorOnSurface),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
            const SizedBox(height: 30),
            Container(
                width: 130,
                height: 1,
                color: Constants.colorSecondary.withAlpha(90)),
            const SizedBox(height: 40),
            SIngleCard(
                imagePath: 'assets/Profile_icon.png',
                title: 'Find and Invite',
                onClick: () => Get.toNamed(FindAndViewScreen.route)),
            const SizedBox(height: 20),
            SIngleCard(
                imagePath: 'assets/Lock.png',
                title: 'Reset Password',
                onClick: () {
                  Get.to(const ResetPassword());
                }),
            const SizedBox(height: 20),
            SIngleCard(
                imagePath: 'assets/Lock.png',
                title: 'Privacy & Security',
                onClick: () {}),
            const SizedBox(height: 40),
            Container(
                width: 130,
                height: 1,
                color: Constants.colorSecondary.withAlpha(90)),
            const SizedBox(height: 40),
            SIngleCard(
                textColor: Constants.colorError,
                imagePath: 'assets/Info-Square.png',
                title: 'Logout',
                onClick: () async {
                  await FirestoreDatabaseHelper.instance()
                      .emptyToken(controller.user?.id ?? '');

                  await SharedPreferenceHelper.instance.clear();
                  await FirebaseAuthHelper.instance().signout();
                  Get.toNamed(WelcomeScreen.route);
                }),
          ],
        ),
      ),
    );
  }
}

class SIngleCard extends StatelessWidget {
  const SIngleCard(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.onClick,
      this.textColor = Constants.colorSecondary});

  final String imagePath;
  final String title;
  final VoidCallback onClick;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick.call();
      },
      child: Row(
        children: [
          ImageIcon(
            AssetImage(imagePath),
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
                fontSize: 17,
                fontFamily: Constants.workSansSemibold,
                color: textColor),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }
}
