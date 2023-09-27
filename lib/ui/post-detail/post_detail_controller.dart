import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/backend/shared_web_service.dart';
import 'package:smartx_flutter_app/helper/firestore_database_helper.dart';
import 'package:smartx_flutter_app/helper/shared_preference_helpert.dart';
import 'package:http/http.dart' as http;
import 'package:smartx_flutter_app/models/comment_model.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';

class PostDetailController extends GetxController {
  PostModel postModel;
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  PostDetailController({required this.postModel}) {
    getCurrentUser();
  }
  TextEditingController commentsTECController = TextEditingController();
  ScrollController commentScroll = ScrollController();

  sendNotification(String token, Map<String, dynamic> data) async {
    //   {
    //     "to":"c1VJDyBjQaq2LOZtB6KqPB:APA91bEd3IN6dvd2BdwT-LeBj4ziVTtF88fg8cpTz3md7r2RnGaiqLaFKInW3ulUsHwWH3SpV9aTzdmPlDRy2uUOk-6a8LTnyis8Z9MSzInVMcrK9g87wJuDeIrzLKjwS0EzPIdGl8Ts",
    //   "notification":{
    //   "title":"Portugal vs. Denmark",
    //   "body":"great match!"
    // },
    //   "data" : {
    //   "body" : "Body of Your Notification in Data",
    //   "title": "Title of Your Notification in Title"
    //
    // }
    // }
    final uri = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final res = await http.post(uri, body: data, headers: {
      'Authorization':
          'key=AAAAvPso1_Y:APA91bHL1luhLDH_sHJaZ3YMgsGjWOgvwRSSmn8PcQM1cy_lTVuvzqegG0acMDP8_YwSOTidgunPXvLYz5pAvhuQlqvxVNuNCshG7XxGmHYAHopv6Ub9vq4q_ohHPHDxfcDArCTCzk1l'
    });
  }

  getCurrentUser() {
    print("Here");
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .snapshots()
        .listen((event) {
      print(event.data());
      print("event data");
      final user = UserModel.fromJson(event.data()!);
      userModel.value = user;
    });
  }

// Implement _toggleLike function
  void toggleLike(PostModel post, bool isLiked) async {
    final user = FirebaseAuth.instance.currentUser;

    List<String> likes = post.likedUsers;

    if (isLiked) {
      postModel = postModel.copyWith(
          isLiked: !isLiked, totalLikes: postModel.totalLikes - 1);
      update();
      likes.remove(user?.uid);
    } else {
      likes.add(user!.uid);
      postModel = postModel.copyWith(
          isLiked: !isLiked, totalLikes: postModel.totalLikes + 1);
      update();
    }

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .update({'likedUsers': likes, 'totalLikes': likes.length});
  }
  deleteComment(CommentModel comment) async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('comments')
        .doc(postModel.id)
        .collection("comments").doc(comment.id).delete();
    await FirebaseFirestore.instance.collection("user").doc(uid).update({
      "userComments": userModel.value!.userComments! - 1
    });
    var counts = postModel.commentsCount - 1;
    await FirebaseFirestore.instance.collection("posts").doc(postModel.id).update({
      "commentsCount": postModel.commentsCount - 1
    });
    postModel = postModel.copyWith(commentsCount: counts);
  }
  void commentToggleLike(CommentModel comment, bool isLiked) async {
    final user = FirebaseAuth.instance.currentUser;

    List<String> likes = comment.likedUsers;

    if (isLiked) {
      likes.remove(user?.uid);
    } else {
      likes.add(user!.uid);
    }

    await FirebaseFirestore.instance
        .collection('comments')
        .doc(postModel.id)
        .collection('comments')
        .doc(comment.id)
        .update({'likedUsers': likes,});
  }
  updateUser() async {
    if (userModel.value != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection("user").doc(uid).update({
        "userComments": (userModel.value!.userComments == null)
            ? 0 + 1
            : userModel.value!.userComments! + 1
      });
    }
  }

  uploadComment() async {
    if (commentsTECController.text.isEmpty) return;

    final user = await SharedPreferenceHelper.instance.user;
    if (user == null) return;
    var doc = FirebaseFirestore.instance
        .collection('comments')
        .doc(postModel.id)
        .collection("comments").doc();
    await doc.set({
      "username": '${user.firstName} ${user.lastName}',
      "comment": commentsTECController.text,
      "timestamp": Timestamp.now(),
      "userDp": user.imagePath,
      "userId": user.id,
      "id":doc.id
    }).whenComplete(() async {
      commentsTECController.clear();

      postModel =
          postModel.copyWith(commentsCount: postModel.commentsCount + 1);
      update();
      1.delay(() {
        commentScroll.animateTo(commentScroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
      });
      if (user.id != postModel.userid) {
        final token = await FirestoreDatabaseHelper.instance()
            .getUserToken(postModel.userid);
        if (token != null) {
          SharedWebService.instance().sendNotification('', {
            "to": token,
            "notification": {
              "title": "SmartX",
              "body": "${user.firstName ?? ''} commented on your post."
            },
            'priority': 'high',
          });
        }
      }
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postModel.id)
          .update({'commentsCount': postModel.commentsCount});
    });
  }
}
