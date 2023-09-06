import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/models/notification_model.dart';
import 'package:smartx_flutter_app/models/post_model.dart';

import '../../post-detail/post_detail_screen.dart';

class NotificationController extends GetxController {
  NotificationController() {
    getNotifications();
  }
  static const String _USER = 'user';
  static const String _POST = 'posts';
  static const String _NOTIFICATIONS = 'notifications';
  RxList notifications = [].obs;
  getNotifications() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    List<NotificationModel> tempList = [];
    FirebaseFirestore.instance
        .collection(_USER)
        .doc(uid)
        .collection(_NOTIFICATIONS)
        .snapshots()
        .listen((event) {
      tempList = [];
      for (var element in event.docs) {
        tempList.add(NotificationModel.fromJson(element.data()));
      }
      notifications.value = tempList;
    });
  }

  getCurrentPost(NotificationModel model) async {
    PostModel? postModel;
    final documentReference = await FirebaseFirestore.instance
        .collection(_POST)
        .where("id", isEqualTo: model.postId)
        .get();
    if (documentReference.docs.isEmpty) return null;
    return documentReference.docs.map((e) {
      postModel = PostModel.fromJson(e.data());
      if (postModel != null) {
        Get.back();
        Get.toNamed(PostDetailScreen.route, arguments: postModel);
      }
      return postModel;
    }).toList();
  }
}
