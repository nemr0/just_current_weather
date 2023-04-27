part of 'weather_cubit.dart';

@immutable

/// Abstract Immutable Class of WeatherCubit emitting [WeatherState].
abstract class WeatherState {}

/// Emitted when Getting Device Current Location.
class LoadingCurrentLocationState extends WeatherState {}

/// Emitted when Successfully Got Device's Current Location.
class GotLocationState extends WeatherState {
  final Position position;
  GotLocationState(this.position);
}

/// Emitted when There's Error Getting Device's Current Location.
class LocationExceptionState extends WeatherState {
  final PlatformException exception;
  LocationExceptionState(this.exception);
}

/// Emitted when Getting Weather using API.
class LoadingCurrentWeatherState extends WeatherState {}

/// Emitted when API Successfully Responded
class GotWeatherState extends WeatherState {
  final Weather weather;
  GotWeatherState(this.weather);
}

/// Emitted when There's an Exception Getting Data From API.
class WeatherExceptionState extends WeatherState {
  final DioError dioError;
  WeatherExceptionState(this.dioError);
}
