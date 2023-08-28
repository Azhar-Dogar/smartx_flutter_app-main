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