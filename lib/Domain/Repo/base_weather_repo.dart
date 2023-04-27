
import '../Entities/weather.dart';

/// domain/repo abstract contract
abstract class BaseWeatherRepo {
  Future<Weather> getWeatherByLocation(double lat, double lon);
}
