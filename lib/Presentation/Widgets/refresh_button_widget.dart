import 'package:flutter/material.dart';
import 'package:just_current_weather/Presentation/Bloc/weather_cubit.dart';

/// refresh button uses [WeatherCubit] to re-get location to redo the Weather-Get-Cycle.
class RefreshButtonWidget extends StatelessWidget {
  const RefreshButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.resolveWith(
                (states) => const Size(30, 30)),
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.black54)),
        child: const Icon(
          Icons.refresh_rounded,
          color: Colors.white70,
          size: 20,
        ),
        onPressed: () {
          WeatherCubit.get(context).getCurrentLocationNow();
        });
  }
}
