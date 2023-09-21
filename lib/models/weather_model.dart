class WeatherModel {
  String time;
  double waterRange;
  WeatherModel(
      {
    required this.time,
        required this.waterRange
});
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
    time: json['time'],
    waterRange: json['waterRange']
    );
  }
  Map<String, dynamic> toJson() => {
    "time": time,
    "waterRange": waterRange,
  };
}
