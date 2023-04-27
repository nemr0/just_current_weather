import 'package:weather_app/Domain/Entities/weather.dart';

/// domain/repo abstract contract
abstract class BaseWeatherRepo {
  Future<Weather> getWeatherByLocation(double lat, double lon);
}
