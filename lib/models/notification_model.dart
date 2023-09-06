import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  String id;
  String userId;
  String postId;
  Timestamp dateTime;
  NotificationModel({
    required this.id,
    required this.userId,
    required this.dateTime,
    required this.postId,
});
  factory NotificationModel.fromJson(Map<String,dynamic> data){
    return NotificationModel(
        id: data["id"],
        postId: data['postId'],
        userId: data["userId"],
        dateTime: data["dateTime"]);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['dateTime'] = dateTime;
    data['postId'] = postId;
    return data;
  }
}