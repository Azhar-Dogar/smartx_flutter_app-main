import 'package:cloud_firestore/cloud_firestore.dart';

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