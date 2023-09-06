import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  String id;
  String userId;
  String postId;
  String groupId;
  Timestamp dateTime;
  bool isComment;
  bool seen;
  NotificationModel({
    required this.id,
    required this.groupId,
    required this.seen,
    required this.isComment,
    required this.userId,
    required this.dateTime,
    required this.postId,
});
  factory NotificationModel.fromJson(Map<String,dynamic> data){
    return NotificationModel(
        id: data["id"],
        groupId: data['groupId'],
        isComment: data['isComment'],
        postId: data['postId'],
        seen: data['seen'],
        userId: data["userId"],
        dateTime: data["dateTime"]);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['dateTime'] = dateTime;
    data['postId'] = postId;
    data['groupId'] = groupId;
    data['seen'] = seen;
    data['isComment'] = isComment;
    return data;
  }
}