import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _wetherService = WeatherService(
    apiKey: 'a56c831db82bde36a3f4b717a341ced8',
  );
  Weather? _weather;
  _fetchWeather() async {
    try {
      String city = await _wetherService.getCurrentCity();
      final weather = await _wetherService.getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("$e 11111111111");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _weather == null
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white, size: 150))
          : Center(child: WeatherCard(weather: _weather)),
    );
  }
}

class WeatherCard extends StatelessWidget {
  const WeatherCard({
    super.key,
    required Weather? weather,
  }) : _weather = weather;

  final Weather? _weather;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text(
        _weather!.cityName,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      Lottie.asset(
        getCurrentWeatherIcon(
          _weather!.mainCondition,
        ),
      ),
      Text(
        "${_weather!.temperature.toDouble().truncate()}°C",
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      Text(_weather!.mainCondition,
          style: Theme.of(context).textTheme.headlineSmall),
    ]);
  }
}

String getCurrentWeatherIcon(
  String mainCondition,
) {
  switch (mainCondition.toLowerCase()) {
    case 'clear':
      return 'assets/sun.json';
    case 'clouds':
      return 'assets/clouds.json';
    case 'rain':
      return 'assets/rain.json';
    case 'snow':
      return 'assets/snow.json';
    default:
      return 'assets/sun.json';
  }
}
