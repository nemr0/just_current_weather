import '../../Domain/Entities/weather.dart';
import '../../Domain/Repo/base_weather_repo.dart';
import '../Datasource/remote_datasource/remote_datasource.dart';

class WeatherRepo implements BaseWeatherRepo {
  final BaseRemoteDataSource remoteDataSource;
  WeatherRepo(this.remoteDataSource);
  @override
  Future<Weather> getWeatherByLocation(double lat, double lon) async =>
      await remoteDataSource.getWeatherByLocation(lat, lon);
}
