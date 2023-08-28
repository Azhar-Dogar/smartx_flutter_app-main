
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WalkModel {
  String id;
  int duration;
  double distance;
  List<LatLng> paths = [];
  WalkModel({
    required this.paths,
    required this.duration,
    required this.distance,
    required this.id
  });

  factory WalkModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final duration = json['duration'];
    final distance = json['distance'];
   final paths = json['paths'];
    return WalkModel(
        id: id,
        duration: duration,
        distance: distance,
      paths : paths
        );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['duration'] = duration;
    data['distance'] = distance;
    data['paths'] = mapFunc();
    return data;
  }
  List<Map<String,double>> mapFunc() {
  List<Map<String, double>> latLngMaps = paths.map((latLng) {
    return {
      'latitude': latLng.latitude,
      'longitude': latLng.longitude,
    };
  }).toList();
  return latLngMaps;
  }
}
