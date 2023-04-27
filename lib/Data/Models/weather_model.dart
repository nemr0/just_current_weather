import '../../Domain/Entities/weather.dart';

class WeatherModel extends Weather {
  WeatherModel(
      {required super.id,
      required super.humidity,
      required super.pressure,
      required super.main,
      required super.description,
      required super.name,
      required super.country,
      required super.tempMin,
      required super.tempMax,
      required super.temp,
      required super.icon,
      required super.feelsLike});
  factory WeatherModel.fromJSON(Map<String, dynamic> json) {
    final Map<String, dynamic> weatherMap = json['weather'][0];
    final Map<String, dynamic> mainMap = json['main'];
    return WeatherModel(
      icon: weatherMap['icon'],
      id: json['id'],
      main: weatherMap['main'],
      description: weatherMap['description'],
      name: json['name'],
      country: json['sys']['country'],
      tempMin: double.parse(mainMap['temp_min'].toString()),
      tempMax: double.parse(mainMap['temp_max'].toString()),
      temp: double.parse(mainMap['temp'].toString()),
      feelsLike: mainMap['feels_like'],
      humidity: mainMap['humidity'],
      pressure: mainMap['pressure'],
    );
  }
}
