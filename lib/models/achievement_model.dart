import 'package:cloud_firestore/cloud_firestore.dart';

class AchievementModel {
  String title;
  String id;
  int dateTime;
  String description;
  int count;
  AchievementModel({required this.title,
    required this.id,
    required this.count,
    required this.dateTime,
    required this.description
  });
  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
        title: json['title'],
        id: json['id'],
        count: json['count'],
        dateTime: json['dateTime'],
        description: json['description']
    );
  }
  Map<String,dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['count'] = count;
    data['dateTime'] = dateTime;
    data['description'] = description;
    return data;
}
}
