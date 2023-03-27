class WeatherModel {
  final String location;
  final double temperatureC;
  final String conditionText;
  final String lastUpdated;
  final String icon;

  WeatherModel({
    this.location = "",
    this.temperatureC = 0,
    this.conditionText = "",
    this.lastUpdated = "",
    this.icon = "",
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      location: json['location']['name'],
      temperatureC: json['current']['temp_c'],
      conditionText: json['current']['condition']['text'],
      lastUpdated: json['current']['last_updated'],
      icon: json['current']['condition']['icon'],
    );
  }
}
