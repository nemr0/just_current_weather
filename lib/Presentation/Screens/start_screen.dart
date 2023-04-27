import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:weather_app/Core/TextStyles/ts.dart';
import 'package:weather_app/Domain/Entities/weather.dart';
import 'package:weather_app/Presentation/Bloc/weather_cubit.dart';

class WeatherScreen extends HookWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// day toggle bool
    final day = useState<SMIBool?>(null);

    /// night toggle bool
    final night = useState<SMIBool?>(null);

    /// setting day and night SMIBool(s) on rive init
    void onRiveInit(Artboard artBoard) {
      // Get State Machine Controller for the state machine called "loop"
      final controller = StateMachineController.fromArtboard(artBoard, 'loop');
      artBoard.addController(controller!);
      // Get a reference to the "hover" state machine input
      day.value = controller.findInput<bool>('day') as SMIBool;
      night.value = controller.findInput<bool>('night') as SMIBool;
    }

    /// Change Wallpaper Day or Night According to current time
    /// if current is null will go back to swing mode between day and night
    changeWallpaperState({DateTime? current}) {
      if (current == null) {
        if (day.value != null) day.value?.value = false;
        if (night.value != null) night.value?.value = false;
        return;
      }
      if ((current.hour) > 17 || (current.hour) < 5) {
        if (day.value != null) day.value?.value = true;
        if (night.value != null) night.value?.value = false;
      } else {
        if (night.value != null) night.value?.value = true;
        if (day.value != null) day.value?.value = false;
      }
      return;
    }

    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if (state is LoadingCurrentLocationState) {
          changeWallpaperState();
        } else if (state is LocationExceptionState) {
          changeWallpaperState(current: DateTime.now());
        } else if (state is GotLocationState) {
          changeWallpaperState();
          WeatherCubit.get(context).getCurrentWeatherNow(state.position);
        } else if (state is LoadingCurrentWeatherState) {
          changeWallpaperState();
        } else if (state is WeatherException) {
          changeWallpaperState(current: DateTime.now());
        }
        // weather data
        else if (state is GotWeatherState) {
          changeWallpaperState(current: DateTime.now());
        } else {
          changeWallpaperState(current: DateTime.now());
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            RiveAnimation.asset(
              'assets/background.riv',
              fit: BoxFit.cover,
              placeHolder: const Placeholder(
                color: Color(0xff6FC3F0),
                child: CircularProgressIndicator(
                  color: Colors.white70,
                  backgroundColor: Colors.black,
                  strokeWidth: 2,
                ),
              ),
              onInit: onRiveInit,
            ),
            Center(
              child: GlassmorphicContainer(
                width: 300,
                height: 300,
                borderRadius: 10,
                alignment: Alignment.center,
                linearGradient: const LinearGradient(
                    colors: [Colors.black26, Colors.black54]),
                border: 1,
                blur: 12,
                borderGradient: const LinearGradient(
                    colors: [Colors.black38, Colors.black26]),
                child: ((state is LoadingCurrentLocationState) ||
                        (state is GotLocationState))
                    ? const LoadingWeatherWidget(
                        loadingMsg: 'Getting Current Location',
                        hint: '*please allow location!*',
                      )
                    : (state is LocationExceptionState)
                        ? WeatherExceptionWidget(
                            msg: state.exception.message,
                            code: state.exception.code,
                          )
                        : (state is LoadingCurrentWeatherState)
                            ? const LoadingWeatherWidget(
                                loadingMsg: 'Getting Data From API!',
                              )
                            : (state is WeatherException)
                                ? WeatherExceptionWidget(
                                    code: 'connection-error: ',
                                    msg: state.dioError.message)
                                : (state is GotWeatherState)
                                    ? WeatherDetails(
                                        state.weather,
                                      )
                                    : const WeatherExceptionWidget(
                                        msg:
                                            'Unknown Error, Please Try Again!'),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: (MediaQuery.of(context).size.width * .5) - 60,
              child: GlassmorphicContainer(
                padding: const EdgeInsets.all(10),
                width: 120,
                height: 120,
                alignment: Alignment.center,
                linearGradient: const LinearGradient(
                    colors: [Colors.black26, Colors.black54]),
                border: 1,
                blur: 12,
                borderGradient: const LinearGradient(
                    colors: [Colors.black38, Colors.black26]),
                borderRadius: 10,
                child: Image.asset(
                  'assets/logo.png',
                  height: 80,
                  width: 80,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

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
          Text(
            '${weather.temp} C',
            style: kTitleATS,
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
        '${weather.description}',
        style: kBodyTS,
      )
    ]);
  }
}

class WeatherExceptionWidget extends StatelessWidget {
  const WeatherExceptionWidget({Key? key, this.code, required this.msg})
      : super(key: key);
  final String? code;
  final String? msg;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
        )
      ],
    );
  }
}

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
          )
      ],
    );
  }
}
