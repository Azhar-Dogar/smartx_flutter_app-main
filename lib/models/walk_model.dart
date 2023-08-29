import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dog_model.dart';

class WalkModel {
  String id;
  String title;
  int duration;
  double distance;
  List<LatLng> paths = [];
  List<DogModel>? dogs = [];
  WalkModel(
      {this.dogs,
        required this.title,
      required this.paths,
      required this.duration,
      required this.distance,
      required this.id});

  factory WalkModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final title = json['title'];
    final duration = json['duration'];
    final distance = json['distance'];
    final paths = json['paths'];
    final dogs = List.generate(json['dogs'].length, (index) => DogModel.fromJson(json['dogs'][index]));
    return WalkModel(
        id: id,
        title: title,
        duration: duration,
        distance: distance,
        paths: paths.map<LatLng>((dynamic item) {
          double latitude = item['latitude']; // Extract latitude from dynamic item
          double longitude = item['longitude'];
          return LatLng(latitude, longitude);
        }).toList(),
        dogs: dogs);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['duration'] = duration;
    data['distance'] = distance;
    data['paths'] = pathsMap();
    data['dogs'] = dogsMap();
    return data;
  }

  List<Map<String, dynamic>>? dogsMap() {
    List<Map<String, dynamic>>? dogsList = dogs?.map((e) {
      return DogModel(
              name: e.name,
              size: e.size,
              isSelected: e.isSelected,
              id: e.id,
              imagePath: e.imagePath,
              userId: e.userId,
              isGoodWithDogs: e.isGoodWithDogs,
              isGoodWithKids: e.isGoodWithKids,
              isNeutered: e.isNeutered,
              gender: e.gender)
          .toJson();
    }).toList();
    return dogsList;
  }

  List<Map<String, double>> pathsMap() {
    List<Map<String, double>> latLngMaps = paths.map((latLng) {
      return {
        'latitude': latLng.latitude,
        'longitude': latLng.longitude,
      };
    }).toList();
    return latLngMaps;
  }
}
