import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String username;
  String comment;
  Timestamp timestamp;
  String userDp;
  String userId;
  String id;
  final List<String> likedUsers;
  CommentModel({
    required this.username,
    required this.comment,
    required this.likedUsers,
    required this.timestamp,
    required this.userDp,
    required this.id,
    required this.userId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final username = json['username'];
    final comment = json['comment'];
    final timestamp = json['timestamp'];
    final userDp = json['userDp'];
    final userId = json['userId'];
    final id = json['id'];
    final List<String> likedUsers = json.containsKey('likedUsers')
        ? (json['likedUsers'] as List).map((e) => e.toString()).toList()
        : <String>[];
    return CommentModel(
        username: username,
        comment: comment,
        timestamp: timestamp,
        userDp: userDp,
        userId: userId,
        likedUsers: likedUsers,
        id: id??"",
    );
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