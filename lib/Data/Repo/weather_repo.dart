import 'package:weather_app/Data/Datasource/remote_datasource/remote_datasource.dart';
import 'package:weather_app/Domain/Entities/weather.dart';
import 'package:weather_app/Domain/Repo/base_weather_repo.dart';

class WeatherRepo implements BaseWeatherRepo {
  final BaseRemoteDataSource remoteDataSource;
  WeatherRepo(this.remoteDataSource);
  @override
  Future<Weather> getWeatherByLocation(double lat, double lon) async =>
      await remoteDataSource.getWeatherByLocation(lat, lon);
}
