class QuestModel {
  String id;
  String title;
  String description;
  String duration;
  String groupImage;
  List<String> users;
  QuestModel(
      {required this.duration,
        required this.id,
        required this.groupImage,
        required this.users,
        required this.title,
        required this.description});
  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      users:  json.containsKey('users')
          ? (json['users'] as List).map((e) => e.toString()).toList()
          : <String>[],
        duration: json['duration'],
        groupImage: json['groupImage'],
        id: json['id'],
        title: json['title'],
        description: json['description']);
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "duration": duration,
    "users":users,
    "groupImage":groupImage
  };
}
