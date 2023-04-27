import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/Presentation/Handler/get_current_location.dart';
import 'package:flutter/material.dart';
import '../../Data/Datasource/remote_datasource/remote_datasource.dart';
import '../../Data/Repo/weather_repo.dart';
import '../../Domain/Entities/weather.dart';
import '../../Domain/Usecase/get_weather_by_city.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(LoadingCurrentLocationState());

  getCurrentLocationNow() async {
    try {
      Position p = await getCurrentLocation();
      if (kDebugMode) {
        print('''--- Device Located ---
        Longitude: ${p.longitude}
        Latitude: ${p.latitude}
        === End of Location Data ===''');
      }
      emit(GotLocationState(p));
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      emit(LocationExceptionState(e));
    }
  }

  getCurrentWeatherNow(Position position) async {
    try {
      Weather weather =
          await GetWeatherByLocation(WeatherRepo(RemoteDataSource()))
              .execute(position.latitude, position.longitude);
      emit(GotWeatherState(weather));
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      emit(WeatherException(e));
    }
  }

  /// Get Instance of this cubit using context
  static WeatherCubit get(BuildContext context) =>
      BlocProvider.of<WeatherCubit>(context);
}
