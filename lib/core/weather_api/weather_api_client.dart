import 'dart:math';

import 'package:dio/dio.dart';

import '../models/weather_models.dart';

class WeatherApiClient {
  WeatherApiClient({
    Dio? dio,
    this.apiKey,
  }) : _dio = dio ?? Dio();

  final Dio _dio;
  final String? apiKey;

  /// Fetches weather data for the provided [location].
  ///
  /// If [apiKey] is not set, the client returns a mocked payload so that the UI
  /// can be developed without a backend configuration. Replace the mocked
  /// branch with a real API call once ready.
  Future<WeatherBundle> fetchWeather(LocationPoint location) async {
    if (apiKey == null || apiKey!.isEmpty) {
      return _mockPayload(location);
    }

    // TODO(you): Replace with a concrete API integration (e.g. OpenWeatherMap).
    // The sample below demonstrates the expected structure only.
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: <String, dynamic>{
          'latitude': location.latitude,
          'longitude': location.longitude,
          'hourly': 'temperature_2m,apparent_temperature,relative_humidity_2m,precipitation_probability,wind_speed_10m',
          'daily': 'temperature_2m_max,temperature_2m_min,precipitation_probability_mean',
          'current_weather': true,
          'timezone': 'auto',
        },
      );

      if (response.data == null) {
        return _mockPayload(location);
      }

      return _parseOpenMeteo(response.data!, location);
    } on DioException {
      return _mockPayload(location);
    }
  }

  WeatherBundle _mockPayload(LocationPoint location) {
    final now = DateTime.now();
    final feelsLike = 12 + sin(now.hour / 24 * pi) * 5;

    final current = WeatherSnapshot(
      timestamp: now,
      temperatureC: feelsLike + 1,
      feelsLikeC: feelsLike,
      conditionCode: 'partly-cloudy',
      conditionDescription: '구름 조금',
      precipitationChance: 20,
      windSpeedKph: 12,
      humidityPercent: 55,
    );

    final hourly = List.generate(12, (index) {
      final ts = now.add(Duration(hours: index));
      final temp = feelsLike + sin(index / 4 * pi) * 3;
      return WeatherSnapshot(
        timestamp: ts,
        temperatureC: temp,
        feelsLikeC: temp - 0.5,
        conditionCode: 'partly-cloudy',
        conditionDescription: '구름 조금',
        precipitationChance: index >= 8 ? 60 : 20,
        windSpeedKph: 10 + index.toDouble(),
        humidityPercent: 60,
      );
    });

    final daily = List.generate(7, (index) {
      final day = now.add(Duration(days: index));
      final base = feelsLike + sin(index / 7 * pi) * 4;
      return DailyForecast(
        date: DateTime(day.year, day.month, day.day),
        minTempC: base - 4,
        maxTempC: base + 3,
        conditionCode: 'partly-cloudy',
        conditionDescription: '맑음 후 구름',
        clothingSummary: index == 0 ? '겹쳐 입을 수 있는 아우터 추천' : '가벼운 자켓',
      );
    });

    return WeatherBundle(
      locationName: _locationLabel(location),
      current: current,
      hourly: hourly,
      daily: daily,
      timezone: 'Asia/Seoul',
    );
  }

  WeatherBundle _parseOpenMeteo(
    Map<String, dynamic> payload,
    LocationPoint location,
  ) {
    final current = payload['current_weather'] as Map<String, dynamic>?;
    final timezone = payload['timezone'] as String? ?? 'local';

    WeatherSnapshot currentSnapshot;
    if (current != null) {
      final timeString = current['time'] as String? ?? '';
      final timestamp = DateTime.tryParse(timeString) ?? DateTime.now();
      currentSnapshot = WeatherSnapshot(
        timestamp: timestamp,
        temperatureC: (current['temperature'] as num?)?.toDouble() ?? 0,
        feelsLikeC: (current['apparent_temperature'] as num?)?.toDouble() ??
            (current['temperature'] as num?)?.toDouble() ??
            0,
        conditionCode: '${current['weathercode']}',
        conditionDescription: '실시간 데이터',
        precipitationChance: 0,
        windSpeedKph: (current['windspeed'] as num?)?.toDouble() ?? 0,
        humidityPercent: 0,
      );
    } else {
      currentSnapshot = _mockPayload(location).current;
    }

    return WeatherBundle(
      locationName: payload['timezone_abbreviation'] as String? ??
          _locationLabel(location),
      current: currentSnapshot,
      hourly: const [],
      daily: const [],
      timezone: timezone,
    );
  }
}

String _locationLabel(LocationPoint location) {
  final parts = <String>[
    if (location.city.trim().isNotEmpty) location.city.trim(),
    if (location.district.trim().isNotEmpty) location.district.trim(),
    if (location.locality.trim().isNotEmpty &&
        location.locality.trim() !=
            '${location.city.trim()} ${location.district.trim()}')
      location.locality.trim(),
  ]..removeWhere((element) => element.isEmpty);

  return parts.isNotEmpty ? parts.join(' ') : '현재 위치';
}
