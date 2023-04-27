import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_current_weather/Presentation/bloc_observer.dart';

import 'Presentation/Bloc/weather_cubit.dart';
import 'Presentation/Screens/weather_screen.dart';

void main() async {
  Bloc.observer = CustomBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit()..getCurrentLocationNow(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Just Current Weather',
        theme: ThemeData.dark(),
        home: const WeatherScreen(),
      ),
    );
  }
}
