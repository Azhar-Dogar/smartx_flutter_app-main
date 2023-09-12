class QuestModel {
  String id;
  String title;
  String description;
  String duration;
  QuestModel(
      {required this.duration,
        required this.id,
        required this.title,
        required this.description});
  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
        duration: json['duration'],
        id: json['id'],
        title: json['title'],
        description: json['description']);
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "duration": duration
  };
}
