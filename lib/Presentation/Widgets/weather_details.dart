import 'package:flutter/material.dart';
import 'package:just_current_weather/Presentation/Widgets/refresh_button_widget.dart';

import '../../Core/TextStyles/ts.dart';
import '../../Domain/Entities/weather.dart';

/// if [WeatherState] is [GotWeatherState]
/// this widget shows weather details from [Weather] object.
class WeatherDetails extends StatelessWidget {
  const WeatherDetails(
    this.weather, {
    super.key,
  });

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://openweathermap.org/img/wn/${weather.icon}.png',
            height: 60,
            width: 60,
            fit: BoxFit.contain,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '${weather.main}!',
            style: kBodyTS,
          )
        ],
      ),
      Text(
        '${weather.temp} C',
        style: kTitleATS,
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        '${weather.tempMin} C - ${weather.tempMax} C',
        style: kTitleTS,
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        '${weather.name},${weather.country}',
        style: kTitleTS,
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        //ignore:unnecessary_string_interpolations
        '${weather.description}',
        style: kBodyTS,
      ),
      const SizedBox(
        height: 10,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Tooltip(
          message: 'Pressure',
          child: Image.asset(
            'assets/pressure.png',
            height: 20,
            width: 20,
          ),
        ),
        Text(
          weather.pressure.toString(),
          style: kTitleTS,
        ),
      ]),
      const SizedBox(
        height: 10,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Tooltip(
          message: 'Humidity',
          child: Image.asset(
            'assets/humidity.png',
            height: 20,
            width: 20,
          ),
        ),
        Text(
          weather.humidity.toString(),
          style: kTitleTS,
        ),
      ]),
      const SizedBox(
        height: 10,
      ),
      const RefreshButtonWidget()
    ]);
  }
}
