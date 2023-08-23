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

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String id;
  final String fcmToken;
  final String? city;
  final String? bio;
  final String? country;
  final String? imagePath;
  final String? created;
  final bool isFollowing;

  UserModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.id,
      required this.fcmToken,
      this.isFollowing = false,
      this.bio,
      this.created,
      this.country,
      this.city,
      this.imagePath});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final String fname =
        json.containsKey('firstName') ? json['firstName'] ?? '' : '';
    final String fcmToken =
        json.containsKey('fcmToken') ? json['fcmToken'] ?? '' : '';
    final String lname =
        json.containsKey('lastName') ? json['lastName'] ?? '' : '';
    final String email = json.containsKey('email') ? json['email'] ?? '' : '';
    final String city = json.containsKey('city') ? json['city'] ?? '' : '';
    final String imagePath =
        json.containsKey('imagePath') ? json['imagePath'] ?? '' : '';
    final String bio = json.containsKey('bio') ? json['bio'] ?? '' : '';
    final String created =
        json.containsKey('created') ? json['created'].toString() : '';
    final String country =
        json.containsKey('country') ? json['country'] ?? '' : '';
    final String id = json.containsKey('id') ? json['id'] ?? '' : '';

    return UserModel(
        firstName: fname,
        lastName: lname,
        email: email,
        isFollowing: false,
        fcmToken: fcmToken,
        id: id,
        created: created,
        bio: bio,
        imagePath: imagePath,
        country: country,
        city: city);
  }

  UserModel copyWith(
          {String? firstName,
          String? lastName,
          String? city,
          String? bio,
          String? fcmToken,
          bool? isFollowing,
          String? country,
          String? imagePath,
          String? email,
          String? id}) =>
      UserModel(
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          isFollowing: isFollowing ?? this.isFollowing,
          city: city ?? this.city,
          fcmToken: fcmToken ?? this.fcmToken,
          imagePath: imagePath ?? this.imagePath,
          email: email ?? this.email,
          created: created,
          country: country ?? this.country,
          bio: bio ?? this.bio,
          id: id ?? this.id);

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'id': id,
        'city': city,
        'bio': bio,
        'imagePath': imagePath,
        'country': country,
        'fcmToken': fcmToken,
        'created': FieldValue.serverTimestamp()
      };

  Map<String, dynamic> toWithoutDateJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'id': id,
        'city': city,
        'bio': bio,
        'fcmToken': fcmToken,
        'imagePath': imagePath,
        'country': country,
      };

  @override
  String toString() {
    return 'LoginResponse{firstName: $firstName,isFollowing :$isFollowing,  email: $email, id: $id,imagePath :$imagePath,phone : $city,country : $country}';
  }
}

class DogModel {
  final String name;
  final String size;
  final String id;
  final String userId;
  final String gender;
  final bool isGoodWithDogs;
  final bool isGoodWithKids;
  final bool isNeutered;

  final String? imagePath;

  DogModel(
      {required this.name,
      required this.size,
      required this.id,
      required this.userId,
      required this.isGoodWithDogs,
      required this.isGoodWithKids,
      required this.isNeutered,
      required this.gender,
      this.imagePath});

  factory DogModel.fromJson(Map<String, dynamic> json) {
    final String name = json.containsKey('name') ? json['name'] : '';
    final String gender = json.containsKey('gender') ? json['gender'] : '';
    final String size = json.containsKey('size') ? json['size'] : '';
    final String imagePath =
        json.containsKey('imagePath') ? json['imagePath'] ?? '' : '';

    final String id = json.containsKey('id') ? json['id'] ?? '' : '';
    final String userId =
        json.containsKey('userId') ? json['userId'] ?? '' : '';
    final bool isGoodWithDogs = json.containsKey('isGoodWithDogs')
        ? json['isGoodWithDogs'] ?? false
        : false;
    final bool isGoodWithKids = json.containsKey('isGoodWithKids')
        ? json['isGoodWithKids'] ?? false
        : false;
    final bool isNeutered =
        json.containsKey('isNeutered') ? json['isNeutered'] ?? false : false;

    return DogModel(
        name: name,
        userId: userId,
        size: size,
        gender: gender,
        isGoodWithDogs: isGoodWithDogs,
        isGoodWithKids: isGoodWithKids,
        isNeutered: isNeutered,
        id: id,
        imagePath: imagePath);
  }

  DogModel copyWith(
          {String? name, String? imagePath, String? size, String? id}) =>
      DogModel(
          name: name ?? this.name,
          imagePath: imagePath ?? this.imagePath,
          size: size ?? this.size,
          isNeutered: isNeutered,
          userId: userId,
          isGoodWithKids: isGoodWithKids,
          isGoodWithDogs: isGoodWithDogs,
          gender: gender,
          id: id ?? this.id);

  Map<String, dynamic> toJson() => {
        'name': name,
        'size': size,
        'gender': gender,
        'isNeutered': isNeutered,
        'isGoodWithKids': isGoodWithKids,
        'isGoodWithDogs': isGoodWithDogs,
        'id': id,
        'userId': userId,
        'imagePath': imagePath
      };

  @override
  String toString() {
    return 'DogModelResponse{firstName: $name,  email: $size, id: $id,imagePath :$imagePath}';
  }
}

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

  PostModel(
      {required this.text,
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
      this.imagePath});

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
    );
  }

  PostModel copyWith(
          {String? text,
          String? imagePath,
          String? userid,
          bool? isLiked,
          List<String>? likedUsers,
          num? totalLikes,
          num? commentsCount,
          String? username,
          String? userImage,
          String? id}) =>
      PostModel(
          text: text ?? this.text,
          likedUsers: likedUsers ?? this.likedUsers,
          isLiked: isLiked ?? this.isLiked,
          commentsCount: commentsCount ?? this.commentsCount,
          totalLikes: totalLikes ?? this.totalLikes,
          imagePath: imagePath ?? this.imagePath,
          userImage: userImage ?? this.userImage,
          username: username ?? this.username,
          userid: userid ?? this.userid,
          created: created,
          id: id ?? this.id);

  Map<String, dynamic> toJson() => {
        'text': text,
        'userid': userid,
        'username': username,
        'isLiked': isLiked,
        'userImage': userImage,
        'id': id,
        'imagePath': imagePath,
        'created': FieldValue.serverTimestamp()
      };

  @override
  String toString() {
    return 'PostModelResponse{firstName: $text,isLiked :$isLiked, totalComments : $commentsCount, likes : $totalLikes, userid: $userid, id: $id,imagePath :$imagePath}';
  }
}

class GroupModel {
  final String title;
  final String description;
  final String profileImage;
  final String coverImage;
  final List<String> users;
  final String id;
  final bool isJoined;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'users': users,
      'id': id
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      profileImage: map['profile_image'] ?? '',
      coverImage: map['cover_image'] ?? '',
      users: map.containsKey('users')
          ? (map['users'] as List).map((e) => e.toString()).toList()
          : <String>[],
      id: map['id'] ?? '',
    );
  }

  const GroupModel(
      {required this.title,
      required this.description,
      required this.profileImage,
      required this.coverImage,
      required this.users,
      this.isJoined = false,
      required this.id});

  GroupModel copyWith(
      {String? title,
      String? description,
      String? profileImage,
      String? coverImage,
      List<String>? users,
      String? id,
      bool? isJoined}) {
    return GroupModel(
        title: title ?? this.title,
        description: description ?? this.description,
        profileImage: profileImage ?? this.profileImage,
        coverImage: coverImage ?? this.coverImage,
        users: users ?? this.users,
        id: id ?? this.id,
        isJoined: isJoined ?? this.isJoined);
  }
}
