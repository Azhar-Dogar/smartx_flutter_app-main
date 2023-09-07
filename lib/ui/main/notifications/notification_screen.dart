import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/models/notification_model.dart';
import 'package:smartx_flutter_app/ui/main/notifications/notification_controller.dart';
import 'package:smartx_flutter_app/util/constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../models/user_model.dart';
import '../../../util/functions.dart';
import '../../user-detail/user_detail_controller.dart';

class NotificationScreen extends StatefulWidget {
  static const String route = '/notification_screen_route';
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

final controller = Get.put(NotificationController());

class _NotificationScreenState extends State<NotificationScreen> {
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
          onTap: () => Get.back(),
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
          Obx(() => Expanded(
                    child: ListView.builder(
                        itemCount: controller.notifications.length,
                        itemBuilder: (BuildContext context, index) {
                          return notificationItem(
                              controller.notifications[index], false);
                        }),
                  )
              // notificationItem(true),
              // notificationItem(true),
              )
        ],
      ),
    );
  }

  Widget notificationItem(NotificationModel model, bool isRead) {
    String groupText = "";
    if(model.groupId != ""){
      groupText = " in community group";
    }
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user")
            .doc(model.userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            UserModel user = UserModel.fromJson(snapshot.data.data());
            return InkWell(
              onTap: () {
                Functions.showLoaderDialog(context);
                controller.getCurrentPost(model);
              },
              child: Column(
                children: [
                  Container(
                    color: (model.seen)
                        ? Colors.white
                        : Constants.unreadNotification.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (user.imagePath != null) ...[
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(user.imagePath!),
                                  radius: 25,
                                ),
                              ] else ...[
                                Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    child: Image.asset(
                                      'assets/dummy.png',
                                      height: 40,
                                    ))
                              ],
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${user.firstName} ${user.lastName}",
                                        style: const TextStyle(
                                            fontFamily: Constants.workSansMedium,
                                            color: Constants.colorSecondary)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      model.isComment
                                          ? "Comment on your post$groupText"
                                          : 'Liked your post$groupText',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontFamily: Constants.workSansLight,
                                          color: Constants.colorSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),                              Expanded(
                                child: Text(
                                  timeago.format(model.dateTime.toDate()),
                                  style: const TextStyle(
                                      fontFamily: Constants.workSansRegular,
                                      fontSize: 9),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  )
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
