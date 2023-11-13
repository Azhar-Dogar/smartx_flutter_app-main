import 'package:cloud_firestore/cloud_firestore.dart';

import 'walk_model.dart';

class PostModel {
  final String text;
  final String userid;
  final String username;
  final String userImage;
  final String id;
  final bool isLiked;
  final String? groupId;
  final List<String> likedUsers;
  DateTime created;

  final num commentsCount;
  final num totalLikes;

  final String? imagePath;

  WalkModel? walk;

  PostModel({
    required this.text,
    required this.username,
    required this.userImage,
    required this.userid,
    required this.id,
    required this.created,
    required this.likedUsers,
    this.groupId,
    this.commentsCount = 0,
    this.totalLikes = 0,
    this.isLiked = false,
    this.imagePath,
    this.walk,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final String text = json.containsKey('text') ? json['text'] : '';
    final String groupId = json.containsKey('groupId') ? json['groupId'] : '';
    final num commentsCount =
        json.containsKey('commentsCount') ? json['commentsCount'] : 0;
    final num totalLikes =
        json.containsKey('totalLikes') ? json['totalLikes'] : 0;
    final String userid = json.containsKey('userid') ? json['userid'] : '';
    final bool isLiked =
        json.containsKey('isLiked') ? json['isLiked'] ?? false : false;
    final String username =
        json.containsKey('username') ? json['username'] : '';
    final String userImage =
        json.containsKey('userImage') ? json['userImage'] : '';
    final String imagePath =
        json.containsKey('imagePath') ? json['imagePath'] ?? '' : '';
    final List<String> likedUsers = json.containsKey('likedUsers')
        ? (json['likedUsers'] as List).map((e) => e.toString()).toList()
        : <String>[];

    final String id = json.containsKey('id') ? json['id'] ?? '' : '';
    final DateTime created = json.containsKey('created')
        ? DateTime.fromMicrosecondsSinceEpoch(
            (json['created'] as Timestamp).microsecondsSinceEpoch)
        : DateTime.now();

    var walk = json["walk"] == null ? null : WalkModel.fromJson(json["walk"]);
    return PostModel(
      text: text,
      likedUsers: likedUsers,
      totalLikes: totalLikes,
      userid: userid,
      groupId: groupId,
      isLiked: isLiked,
      created: created,
      userImage: userImage,
      commentsCount: commentsCount,
      username: username,
      id: id,
      imagePath: imagePath,
      walk: walk,
    );
  }

  PostModel copyWith(
          {String? text,
          String? imagePath,
          String? userid,
          bool? isLiked,
          List<String>? likedUsers,
          num? totalLikes,
          String? groupId,
          num? commentsCount,
          String? username,
          String? userImage,
          String? id}) =>
      PostModel(
          text: text ?? this.text,
          likedUsers: likedUsers ?? this.likedUsers,
          isLiked: isLiked ?? this.isLiked,
          groupId: groupId ?? this.groupId,
          commentsCount: commentsCount ?? this.commentsCount,
          totalLikes: totalLikes ?? this.totalLikes,
          imagePath: imagePath ?? this.imagePath,
          userImage: userImage ?? this.userImage,
          username: username ?? this.username,
          userid: userid ?? this.userid,
          created: created,
          id: id ?? this.id,
        walk: walk,
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'userid': userid,
        'username': username,
        'isLiked': isLiked,
        'groupId': groupId,
        'userImage': userImage,
        'id': id,
        'imagePath': imagePath,
        'created': created,
        "walk": walk?.toJson(),
      };

  @override
  String toString() {
    return 'PostModelResponse{firstName: $text,isLiked :$isLiked, totalComments : $commentsCount, likes : $totalLikes, userid: $userid, id: $id,imagePath :$imagePath}';
  }
}
