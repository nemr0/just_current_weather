import 'package:flutter/material.dart';
import 'package:just_current_weather/Presentation/Widgets/refresh_button_widget.dart';

import '../../Core/TextStyles/ts.dart';

/// if [WeatherState] is [LocationExceptionState] or [WeatherExceptionState]
/// this widget shows the exception
class WeatherExceptionWidget extends StatelessWidget {
  const WeatherExceptionWidget({Key? key, this.code, required this.msg})
      : super(key: key);
  final String? code;
  final String? msg;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Icon(
          Icons.error_rounded,
          color: Colors.redAccent,
          size: 30,
        ),
        Text(
          '${code != null ? '${code!}: ' : ''}${msg ?? ''}',
          textAlign: TextAlign.center,
          style: kTitleTS,
        ),
        const RefreshButtonWidget(),
      ],
    );
  }
}
