import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartx_flutter_app/models/achievement_model.dart';
import 'package:smartx_flutter_app/models/dog_model.dart';
import 'package:smartx_flutter_app/models/walk_model.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';

class MapWalkController extends GetxController {
  MapWalkController() {
    getCurrentUser();
    getUserPosts();
    getUserWalks();
  }

  dynamic stream = FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("walks")
      .snapshots();
  static String _USER = "user";
  static String _POSTS = "posts";
  static String _WALKS = "walks";
  static String _ACHIEVEMENTS = "achievements";
  Rx<bool> isStart = Rx<bool>(false);
  RxList badges = [].obs;
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  String userId = FirebaseAuth.instance.currentUser!.uid;
  List<LatLng> pathPoints = [];
  RxDouble totalDistance = 0.0.obs;
  DateTime modified = DateTime.now();
  RxInt minutes = 0.obs;
  RxInt seconds = 0.obs;
  RxInt hours = 0.obs;
  RxList userWalks = [].obs;
  RxList streakList = [].obs;
  RxList userPosts = [].obs;
  DateTime time = DateTime.now();
  int _seconds = 0;
  List<DogModel> selectedDogs = [];
  Timer? timer;
  final titleController = TextEditingController();
  getCurrentUser(){
    print("Here");
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("user").doc(uid).snapshots().listen((event) {
      print(event.data());
      print("event data");
      final user = UserModel.fromJson(event.data()!);
      userModel.value = user;
      if (userModel.value != null) {
        if (userModel.value!.userComments != null) {
          if (userModel.value!.userComments! >= 2) {
        badges.add("20 Comments");
          }
        }
      }
      // print(user.value?.firstName);
      // print("first name");
    });

  }
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  calDistance() {
    double distance = 0;
    for (var i = 0; i < pathPoints.length - 1; i++) {
      distance += calculateDistance(
          pathPoints[i].latitude,
          pathPoints[i].longitude,
          pathPoints[i + 1].latitude,
          pathPoints[i + 1].longitude);
    }
    totalDistance.value = (distance * 1000);
    print("distance $distance");
    print(totalDistance);
    totalDistance;
  }

  void startTimer() {
    modified = DateTime(time.year, time.month, time.day, 00, 00, 00);
    time = modified;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      modified = modified.add(const Duration(seconds: 1));
      minutes.value = modified.minute;
      seconds.value = modified.second;
      hours.value = modified.hour;
    });
  }
  getUserPosts(){
    userPosts = [].obs;
    FirebaseFirestore.instance
        .collection(_POSTS)
        .where("userid",isEqualTo: userId).snapshots().listen((event) {
          // userPosts = [].obs;
          for (var element in event.docs) {
            userPosts.add(PostModel.fromJson(element.data()));
          }
          if(userPosts.length >= 3){
            badges.add("20 Posts");
          }
    });
  }
  getUserComments(){

  }
  getUserWalks() {
    userWalks = [].obs;
    streakList = [].obs;
    FirebaseFirestore.instance
        .collection(_USER)
        .doc(userId)
        .collection(_WALKS).orderBy("dateTime", descending: true)
        .snapshots()
        .listen((event) {
          // RxList tempWalks = [].obs;
          streakList = [].obs;
          DateTime currentDate = DateTime.now();
          DateTime weekStart = currentDate.subtract(const Duration(days: 6));
      for (var element in event.docs) {
        userWalks.add(WalkModel.fromJson(element.data()));
      }
      // print("walks");
      // print(userWalks.length);
      //     AchievementModel? foundModel = achievements.firstWhere((model) => model.title == "1 week streak", orElse: () => null);
      // userWalks = tempWalks;
      //     if(foundModel == null){
      // for(var i = 0; i<7 ; i++ ){
      // for (var element in userWalks) {
      //   if(weekStart.add(Duration(days: i)).day == element.dateTime.day){
      //     print("match");
      //      streakList.add(element);
      //   }
      // }}
      // if(streakList.length>= 4){
      //   // addAchievement();
      // }}
      // print("streak");
      // print(userWalks.length);
      // print(streakList.length);
    });
  }
  addAchievement(){
    CollectionReference ref = FirebaseFirestore.instance
        .collection(_USER)
        .doc(userId)
        .collection(_ACHIEVEMENTS);
    var doc = ref.doc();
    doc.set(AchievementModel(title: "1 week streak", id: doc.id).toJson());
  }
  addWalk() async {
    userWalks = [].obs;
    CollectionReference ref = FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .collection("walks");
    var doc = ref.doc();
    await doc.set(WalkModel(
            title: titleController.text,
            dogs: selectedDogs,
            paths: pathPoints,
            dateTime: DateTime.now().add(const Duration(days: 16)),
            duration: hours.value * 3600 + minutes.value * 60 + seconds.value,
            distance: totalDistance.value,
            id: doc.id)
        .toJson());
  }

  String formatSecondsToHMS(int seconds) {
    int hours = seconds ~/ 3600; // 1 hour = 3600 seconds
    int minutes = (seconds % 3600) ~/ 60; // 1 minute = 60 seconds
    int remainingSeconds = seconds % 60;

    String hoursString = hours.toString().padLeft(2, '0');
    String minutesString = minutes.toString().padLeft(2, '0');
    String secondsString = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursString:$minutesString:$secondsString';
  }
}
