/// Weather Entity
class Weather {
  final int id;
  final String main;
  final String description;
  final String name;
  final String country;
  final double tempMin;
  final double tempMax;
  final double temp;
  final String icon;
  final double feelsLike;
  final int humidity;
  final int pressure;
  const Weather(
      {required this.id,
      required this.humidity,
      required this.pressure,
      required this.feelsLike,
      required this.icon,
      required this.main,
      required this.description,
      required this.name,
      required this.country,
      required this.tempMin,
      required this.tempMax,
      required this.temp});
}
