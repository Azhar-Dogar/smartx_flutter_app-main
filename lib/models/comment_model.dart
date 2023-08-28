import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String username;
  String comment;
  Timestamp timestamp;
  String userDp;
  String userId;

  CommentModel({
    required this.username,
    required this.comment,
    required this.timestamp,
    required this.userDp,
    required this.userId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final username = json['username'];
    final comment = json['comment'];
    final timestamp = json['timestamp'];
    final userDp = json['userDp'];
    final userId = json['userId'];

    return CommentModel(
        username: username,
        comment: comment,
        timestamp: timestamp,
        userDp: userDp,
        userId: userId);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = username;
    data['comment'] = comment;
    data['timestamp'] = timestamp;
    data['userDp'] = userDp;
    data['userId'] = userId;
    return data;
  }
}