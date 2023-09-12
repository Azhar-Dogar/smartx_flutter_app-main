import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/helper/firestore_database_helper.dart';
import 'package:smartx_flutter_app/helper/meta_data.dart';
import 'package:smartx_flutter_app/models/quest_model.dart';

import '../../models/group_model.dart';
import '../../models/post_model.dart';

class GroupDetailController extends GetxController {
  Rx<DataEvent> groupPostEvents = Rx<DataEvent>(const Initial());

  GroupDetailController({required this.groupModel}){
    getGroupPosts();
  }
  GroupModel groupModel;
 final currentUser = FirebaseAuth.instance.currentUser;
  updateTempPost(PostModel model) {
    if (groupPostEvents.value is Data) {
      final list = (groupPostEvents.value as Data).data as List<PostModel>;
      list.insert(0, model);
      groupPostEvents(Data(data: list));
    } else {
      groupPostEvents(Data(data: [model]));
    }
  }
  void toggleLike(PostModel post, bool isLiked) async {
    final user = FirebaseAuth.instance.currentUser;

    List<String> likes = post.likedUsers;

    if (isLiked) {
      likes.remove(user?.uid);
    } else {
      likes.add(user!.uid);
    }

    await FirebaseFirestore.instance.collection('posts').doc(post.id).update({
      'likedUsers': likes,
      'totalLikes': likes.length,
    });
  }
  joinQuest(QuestModel questModel){
    List<String> users = questModel.users;
    users.add(currentUser!.uid);
    FirebaseFirestore.instance.collection("quests").doc(questModel.id).update({
      "users":users
    });
  }
  getGroupPosts() async {
    print("getting group posts");
    groupPostEvents(const Loading());
    try {
      final res =
          await FirestoreDatabaseHelper.instance().getGroupPosts(groupModel.id);
      if (res == null) {
        groupPostEvents(const Empty(message: ''));
        return;
      }
      if (res.isEmpty) {
        groupPostEvents(const Empty(message: ''));
        return;
      }
      groupPostEvents(Data(data: res));
    } catch (_) {
      groupPostEvents(Error(exception: Exception()));
    }
  }
}
