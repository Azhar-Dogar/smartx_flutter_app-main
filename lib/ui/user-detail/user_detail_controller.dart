import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/helper/firestore_database_helper.dart';
import 'package:smartx_flutter_app/helper/meta_data.dart';

import '../../models/dog_model.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';

class UserDetailController extends GetxController {
  Rx<DataEvent> userPostEvents = Rx<DataEvent>(const Initial());
  Rx<DataEvent> userDogEvents = Rx<DataEvent>(const Initial());
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> postStream;
  static const String _POSTS = 'posts';
  final MapEntry mapEntry;
  RxBool isLiked = false.obs;
  RxList<PostModel> posts = <PostModel>[].obs;
  var userId;
  List<DogModel> dogs = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      postStreamSubscription;
  UserDetailController({required this.mapEntry}) {
    userId = (mapEntry.value as UserModel).id;
    postStream = _firebaseFirestore
        .collection(_POSTS)
        .where('userid', isEqualTo: userId)
        .where('groupId', isEqualTo: "")
        .orderBy("created", descending: true)
        .snapshots();
    getUserPosts();
    getUserDogs();
  }

  Rx<int> tabIndex = Rx<int>(0);
  @mustCallSuper
  void dispose() {
    postStreamSubscription?.cancel();
  }

  updateTempPost(PostModel model) {
    if (userPostEvents.value is Data) {
      final list = (userPostEvents.value as Data).data as List<PostModel>;
      list.insert(0, model);
      userPostEvents(Data(data: list));
    } else {
      userPostEvents(Data(data: [model]));
    }
  }

  updateTempDog(DogModel model) {
    if (userDogEvents.value is Data) {
      final list = (userDogEvents.value as Data).data as List<DogModel>;
      list.insert(0, model);
      userDogEvents(Data(data: list));
    } else {
      userDogEvents(Data(data: [model]));
    }
  }

  getUserPosts() async {
    var id = (mapEntry.value as UserModel).id;
    postStreamSubscription = _firebaseFirestore
        .collection(_POSTS)
        .where('userid', isEqualTo: id)
        .where('groupId', isEqualTo: "")
        .orderBy("created", descending: true)
        .snapshots()
        .listen((event) {
      posts.clear();
      event.docs.forEach((element) {
        posts.add(PostModel.fromJson(element.data()));
      });
    });
  }

  Future<DataEvent?> getUserDogs() async {
    userDogEvents(const Loading());
    try {
      var id = (mapEntry.value as UserModel).id;
      final res = await FirestoreDatabaseHelper.instance()
          .getUserDogs((mapEntry.value as UserModel).id);
      if (res == null) {
        userDogEvents(const Empty(message: ''));
        return null;
      }
      if (res.isEmpty) {
        userDogEvents(const Empty(message: ''));
        return null;
      }
      print("events");
      print(res.length);
      return userDogEvents(Data(data: res));
    } catch (_) {
      userDogEvents(Error(exception: Exception()));
    }
  }
}
