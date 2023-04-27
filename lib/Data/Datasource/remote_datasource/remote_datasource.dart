import 'package:flutter/foundation.dart';
import 'package:weather_app/Core/utils/consts.dart';
import 'package:weather_app/Data/Models/weather_model.dart';
import 'package:dio/dio.dart';

abstract class BaseRemoteDataSource {
  Future<WeatherModel> getWeatherByLocation(double lat, double lon);
}

class RemoteDataSource implements BaseRemoteDataSource {
  @override
  Future<WeatherModel> getWeatherByLocation(double lat, double lon) async {
    final Dio dio = Dio();
    try {
      final Response response = await dio.get(
          '${AppConsts.baseURL}/weather?lat=$lat&lon=$lon&appid=${AppConsts.apiKey}&units=metric');
      if (kDebugMode) {
        print('''---GET REQUEST---
>>>>>>> Given:
>>>>>>> Latitude: $lat
>>>>>>> Longitude: $lon
>>>> API Key and Base URL defined in config (--dart-define). <<<
        Response:
        ${response.data}
        ===END OF REQUEST===
        ''');
      }
      return WeatherModel.fromJSON(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
