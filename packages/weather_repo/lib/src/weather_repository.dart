import 'package:weather_api/weather_api.dart' hide Weather;
import 'package:weather_repo/src/extensions/extensions.dart';
import 'package:weather_repo/weather_repo.dart';

class WeatherRepository {
  final WeatherApiClient _weatherApiClient;

  WeatherRepository({
    WeatherApiClient? weatherApiClient,
  }) : _weatherApiClient = weatherApiClient ?? WeatherApiClient();

  Future<Weather> getWeatherByCity({required String city}) async {
    final locationResponse = await _weatherApiClient.getLocationByName(city);
    final weatherResponse = await _weatherApiClient.getWeatherByLatAndLong(
      latitude: locationResponse.latitude,
      longitude: locationResponse.longitude,
    );

    return Weather(
      location: locationResponse.name,
      temperature: weatherResponse.temperature,
      condition: weatherResponse.weatherCode.toInt().toWeatherCondition,
    );
  }
}
