import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_api/weather_api.dart';

class WeatherApiClient {
  final http.Client _httpClient;

  WeatherApiClient({
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  static const _baseUrlWeather = 'api.open-meteo.com';
  static const _baseUrlLocation = 'geocoding-api.open-meteo.com';

  Future<Location> getLocationByName(String query) async {
    final url = Uri.https(_baseUrlLocation, '/v1/search', {
      'name': query,
      'count': 1,
    });

    final response = await _httpClient.get(url);

    if (response.statusCode != 200) {
      throw GetLocationRequestFailedException();
    }

    final jsonData = jsonDecode(response.body) as Map;

    if (!jsonData.containsKey('results')) throw LocationNotFoundException();

    final result = jsonData['results'] as List;

    if (result.isEmpty) throw LocationNotFoundException();

    return Location.fromJson(result.first as Map<String, dynamic>);
  }

  Future<Weather> getWeatherByLatAndLong({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.https(
      _baseUrlWeather,
      'v1/forecast',
      {
        'latitude': latitude,
        'longitude': longitude,
        'current_weather': true,
      },
    );

    final response = await _httpClient.get(url);

    if (response.statusCode != 200) throw GetWeatherRequestFailedException();

    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

    if (!jsonData.containsKey('current_weather')) {
      throw WeatherNotFoundException();
    }

    final result = jsonData['current_weather'] as Map<String, dynamic>;

    return Weather.fromJson(result);
  }
}
