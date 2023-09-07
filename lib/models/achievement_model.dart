class AchievementModel {
  String title;
  String id;
  AchievementModel({required this.title, required this.id});
  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(title: json['title'], id: json['id']);
  }
  Map<String,dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
}
}
