import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:url_launcher/url_launcher.dart';

import '../../Core/TextStyles/ts.dart';
import '../Bloc/weather_cubit.dart';
import '../Widgets/loading_weather_widget.dart';
import '../Widgets/weather_details.dart';
import '../Widgets/weather_exception_widget.dart';

/// Where weather do it all
class WeatherScreen extends HookWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// day toggle bool
    final day = useState<SMIBool?>(null);

    /// night toggle bool
    final night = useState<SMIBool?>(null);
    final scrollCTR = useScrollController();

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
        if (day.value != null) day.value?.value = false;
        if (night.value != null) night.value?.value = true;
      } else {
        if (night.value != null) night.value?.value = false;
        if (day.value != null) day.value?.value = true;
      }
      return;
    }

    const LinearGradient linearGradient = LinearGradient(colors: [
      Color.fromRGBO(140, 185, 238, .4),
      Color.fromRGBO(40, 40, 40, .6),
    ]);
    const LinearGradient borderGradient = LinearGradient(colors: [
      Color.fromRGBO(28, 62, 106, .4),
      Color.fromRGBO(28, 62, 106, .6)
    ]);
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
        } else if (state is WeatherExceptionState) {
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
        return ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbColor:
                MaterialStateColor.resolveWith((states) => Colors.black54),
          ),
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollCTR,
            child: Stack(
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
                  child: SizedBox(
                    width: 300,
                    height: 460,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: ListView(
                        controller: scrollCTR,
                        shrinkWrap: true,
                        children: [
                          GlassmorphicContainer(
                            width: 300,
                            height: 150,
                            alignment: Alignment.center,
                            linearGradient: linearGradient,
                            borderGradient: borderGradient,
                            border: 1,
                            blur: 8,
                            borderRadius: 10,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/logo.png',
                                          height: 80,
                                          width: 80,
                                        ),
                                        FittedBox(
                                          child: Text(
                                            'Just Current Weather',
                                            style: kAppTitleTS,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: IconButton(
                                        splashRadius: 20,
                                        onPressed: () async {
                                          final Uri url =
                                              Uri.parse('https://nemr.me');
                                          if (await canLaunchUrl(url)) {
                                            launchUrl(url);
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.info_sharp,
                                          size: 20,
                                          color: Colors.white70,
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GlassmorphicContainer(
                            width: 300,
                            height: 300,
                            borderRadius: 8,
                            alignment: Alignment.center,
                            linearGradient: linearGradient,
                            borderGradient: borderGradient,
                            border: 1,
                            blur: 12,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 100),
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
                                              loadingMsg:
                                                  'Getting Data From API!',
                                            )
                                          : (state is WeatherExceptionState)
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
