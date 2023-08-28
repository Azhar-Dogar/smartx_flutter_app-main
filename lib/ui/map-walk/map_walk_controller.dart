import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartx_flutter_app/models/walk_model.dart';

class MapWalkController extends GetxController {
  Rx<bool> isStart = Rx<bool>(false);
  List<LatLng> pathPoints = [];
  RxDouble totalDistance = 0.0.obs;
  DateTime modified = DateTime.now();
  RxInt minutes = 0.obs;
  RxInt seconds = 0.obs;
  RxInt hours = 0.obs;
  DateTime time = DateTime.now();
  int _seconds = 0;
  Timer? timer;
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

  addWalk() async {
    print(seconds.value);
    print("hours");
    String docId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference ref = FirebaseFirestore.instance
        .collection("user")
        .doc(docId)
        .collection("walks");
    var doc = ref.doc();
    await doc.set(WalkModel(
      paths: pathPoints,
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
