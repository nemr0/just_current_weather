import 'package:flutter/material.dart';
import 'package:just_current_weather/Presentation/Widgets/refresh_button_widget.dart';

import '../../Core/TextStyles/ts.dart';

/// if [WeatherState] is [LoadingCurrentLocationState]
/// or [LoadingCurrentWeatherState], this widget is showing with a loading msg,
/// and a hint if given
class LoadingWeatherWidget extends StatelessWidget {
  const LoadingWeatherWidget({
    Key? key,
    required this.loadingMsg,
    this.hint,
  }) : super(key: key);
  final String loadingMsg;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          color: Colors.white70,
          backgroundColor: Colors.black,
          strokeWidth: 2,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          loadingMsg,
          style: kTitleTS,
        ),
        if (hint != null)
          const SizedBox(
            height: 10,
          ),
        if (hint != null)
          Text(
            hint!,
            style: kBodyTS,
          ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Stuck on Load?',
          style: kBodyTS,
        ),
        const SizedBox(
          height: 5,
        ),
        const RefreshButtonWidget(),
      ],
    );
  }
}
