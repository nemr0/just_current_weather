import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

List<PlatformException> exceptions = [
// location service disabled
  PlatformException(
      code: 'location-disabled',
      message:
          'Location services are disabled, Please Enable it and try again!'),

// location permission denied
  PlatformException(
      code: 'permissions-disabled',
      message:
          'Location permissions are denied, Please Allow it for this app and try again!'),
// location permission denied for ever
  PlatformException(
      code: 'permissions-forever-denied',
      message:
          'Location permissions are permanently denied, we cannot request permissions, Please Allow it for this app and try again!')
];

Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;
  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    throw exceptions[0];
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      throw exceptions[1];
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    throw exceptions[1];
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
