import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:geolocator/geolocator.dart' as geo_locator;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smartx_flutter_app/models/achievement_model.dart';
import 'package:smartx_flutter_app/models/dog_model.dart';
import 'package:smartx_flutter_app/models/quest_model.dart';
import 'package:smartx_flutter_app/models/walk_model.dart';
import 'package:smartx_flutter_app/models/weather_model.dart';

import '../../helper/meta_data.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import 'package:http/http.dart' as http;

class MapWalkController extends GetxController {
  String? uid;

  MapWalkController({this.uid}) {
    _requestLocationPermission();
    getCurrentUser();
    getUserPosts();
    getUserWalks();
    getAchievement();
  }

  Rx<DataEvent> userAchievements = Rx<DataEvent>(const Initial());
  CollectionReference stream = FirebaseFirestore.instance.collection(_USER);

  // .doc(_uid??userId)
  // .collection(_ACHIEVEMENTS)
  // .snapshots();
  static String _USER = "user";
  static String _POSTS = "posts";
  static String _WALKS = "walks";
  static String _ACHIEVEMENTS = "achievements";
  Rx<bool> isStart = Rx<bool>(false);
  Rx<bool> isPause = Rx<bool>(false);
  RxList badges = [].obs;
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  static String userId = FirebaseAuth.instance.currentUser!.uid;
  List<LatLng> pathPoints = [];
  RxDouble totalDistance = 0.0.obs;
  DateTime modified = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 00, 00, 00);
  RxInt minutes = 0.obs;
  RxInt seconds = 0.obs;
  RxInt hours = 0.obs;
  RxList<WalkModel> userWalks = <WalkModel>[].obs;
  RxList<WeatherModel> hourlyWeather = <WeatherModel>[].obs;
  RxList<AchievementModel> achievements = <AchievementModel>[].obs;
  RxList streakList = [].obs;
  RxList userPosts = [].obs;
  DateTime time = DateTime.now();
  int _seconds = 0;
  RxList<DogModel> selectedDogs = <DogModel>[].obs;
  Timer? timer;
  final titleController = TextEditingController();

  addSelectedDogs(List<DogModel> dogs) {
    selectedDogs.value = dogs;
  }

  clearValues() {
    hours.value = 0;
    minutes.value = 0;
    seconds.value = 0;
    totalDistance.value = 0;
    selectedDogs.clear();
    titleController.clear();
  }

  getCurrentUser() {
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

  getAchievement({String? uid}) async {
    achievements = <AchievementModel>[].obs;
    final documents =
        await stream.doc(uid ?? userId).collection(_ACHIEVEMENTS).get();
    // .listen((event) {

    for (var doc in documents.docs) {
      if (achievements
          .where((element) => element.title == doc.data()["title"])
          .isEmpty) {
        achievements.add(AchievementModel.fromJson(doc.data()));
      }
    }

    achievements.obs;
    print("achievements");
    print(achievements.length);
    update();
    // });
  }

  addQuestStreak(QuestModel questModel) async {
    double totalDistance = 0.0;
    List<WalkModel> questWalks = [];
    for (var i = 0; i < questModel.duration; i++) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      var e =
          userWalks.firstWhere((element) => element.dateTime.day == date.day);
      questWalks.add(e);
    }
    if (questWalks.length == questModel.duration) {
      await addAchievement(questModel.title);
    }
    for (var element in userWalks) {
      totalDistance = totalDistance + element.distance;
    }
    print(totalDistance);
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
    // modified = DateTime(time.year, time.month, time.day, 00, 00, 00);
    time = modified;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      modified = modified.add(const Duration(seconds: 1));
      minutes.value = modified.minute;
      seconds.value = modified.second;
      hours.value = modified.hour;
    });
  }

  getUserPosts() {
    userPosts = [].obs;
    FirebaseFirestore.instance
        .collection(_POSTS)
        .where("userid", isEqualTo: userId)
        .snapshots()
        .listen((event) {
      // userPosts = [].obs;
      for (var element in event.docs) {
        userPosts.add(PostModel.fromJson(element.data()));
      }
      if (userPosts.length >= 3) {
        badges.add("20 Posts");
      }
    });
  }

  getWeatherInfo(LatLng location) async {
    var res = await http.get(Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=${location.latitude}&longitude=${location.longitude}&hourly=rain"));
    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      for (var i = 0; i < jsonData["hourly"]["time"].length; i++) {
        hourlyWeather.add(WeatherModel(
            time: jsonData["hourly"]["time"][i],
            waterRange: jsonData["hourly"]["rain"][i]));
      }
    }
  }

  getUserComments() {}

  getUserWalks() {
    userWalks = <WalkModel>[].obs;
    streakList = [].obs;
    FirebaseFirestore.instance
        .collection(_USER)
        .doc(userId)
        .collection(_WALKS)
        .orderBy("dateTime", descending: true)
        .snapshots()
        .listen((event) {
      List<WalkModel> tempWalks = [];
      streakList = [].obs;
      DateTime currentDate = DateTime.now();
      DateTime weekStart = currentDate.subtract(const Duration(days: 6));
      for (var element in event.docs) {
        tempWalks.add(WalkModel.fromJson(element.data()));
      }
      userWalks.value = tempWalks;
      print("here is user walks");
      print(userWalks.length);
    });
    update();
  }

  addAchievement(String title) async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection(_USER)
        .doc(userId)
        .collection(_ACHIEVEMENTS);
    var doc = ref.doc();
    await doc.set(AchievementModel(title: title, id: doc.id).toJson());
  }

  addWalk() async {
    await getAchievement();
    userWalks = <WalkModel>[].obs;
    CollectionReference ref = FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .collection("walks");
    var doc = ref.doc();
    await doc.set(WalkModel(
            title: titleController.text,
            dogs: selectedDogs,
            paths: pathPoints,
            dateTime: DateTime.now(),
            duration: hours.value * 3600 + minutes.value * 60 + seconds.value,
            distance: totalDistance.value / 1000,
            id: doc.id)
        .toJson());
    if (userWalks.length <= 1) {
      addFirstWalkBadge();
    }
    if (DateTime.now().hour >= 20) {
      addNightOwl();
    } else if (DateTime.now().hour <= 7) {
      addEarlyBird();
    }
    addRainyBadge();
    addWeeklyBadge();
    addMonthlyBadge();
  }

  addFirstWalkBadge() {
    List tempList =
        achievements.where((p0) => p0.title == "First Walk").toList();
    if (tempList.isEmpty) {
      addAchievement("First Walk");
    }
  }

  List<WalkModel> checkStreak(int days) {
    List<WalkModel> streakList = [];
    DateTime currentDate = DateTime.now();
    for (var i = 0; i <= days; i++) {
      List<WalkModel> tempList = userWalks
          .where((p0) =>
              p0.dateTime.day == currentDate.subtract(Duration(days: i)).day)
          .toList();
      // var foundModel = userWalks.firstWhere(
      //     (model) =>
      //         model.dateTime.day == currentDate.subtract(Duration(days: i)).day,
      //     orElse: () => null);
      if (tempList.isNotEmpty) {
        streakList.add(tempList.first);
      }
    }
    return streakList;
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

  addNightOwl() {
    List tempList =
        achievements.where((p0) => p0.title == "Night Owl").toList();
    if (tempList.isEmpty) {
      addAchievement("Night Owl");
    }
  }

  addEarlyBird() {
    List tempList =
        achievements.where((p0) => p0.title == "Early Bird").toList();
    if (tempList.isEmpty) {
      addAchievement("Early Bird");
    }
  }

  addWeeklyBadge() {
    List tempWeek =
        achievements.where((p0) => p0.title == "1 week streak").toList();
    if (tempWeek.isEmpty) {
      List walks = checkStreak(7);
      if (walks.length >= 7) {
        addAchievement("1 week streak");
      }
    }
  }

  addMonthlyBadge() {
    List tempMonth =
        achievements.where((p0) => p0.title == "1 month streak").toList();
    if (tempMonth.isEmpty) {
      List walks = checkStreak(30);
      if (walks.length >= 30) {
        addAchievement("1 month streak");
      }
    }
  }

  addRainyBadge() async {
    bool match = false;
    List tempList =
        achievements.where((p0) => p0.title == "Rainy Walk").toList();
    if (tempList.isEmpty) {
      for (var element in hourlyWeather) {
        DateTime dateTime = DateTime.parse(element.time);
        if (dateTime.day == DateTime.now().day &&
            dateTime.hour == DateTime.now().hour) {
          if (element.waterRange != 0.0) {
            match = true;
          }
          if (match) {
            await addAchievement("Rainy Walk");
            return;
          }
        }
      }
    }
  }

  Future<void> _requestLocationPermission() async {
    final permission_handler.PermissionStatus status =
        await permission_handler.Permission.location.request();
    if (status.isGranted) {
      var location = await _getLocation();
      if (location != null) {
        await getWeatherInfo(location);
      }
    } else {}
  }

  Future<LatLng?> _getLocation() async {
    try {
      geo_locator.Position position =
          await geo_locator.Geolocator.getCurrentPosition(
        desiredAccuracy: geo_locator.LocationAccuracy.high,
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      return null;
    }
  }
}
