import '../Entities/weather.dart';
import '../Repo/base_weather_repo.dart';

// use case to excute in presentation layer
class GetWeatherByLocation {
  final BaseWeatherRepo repo;
  GetWeatherByLocation(this.repo);
  Future<Weather> execute(double lat, double lon) async =>
      await repo.getWeatherByLocation(lat, lon);
}
