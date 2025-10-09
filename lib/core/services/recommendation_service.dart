import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/recommendation.dart';

class RecommendationService {
  RecommendationService();

  static const _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<Recommendation> fetchRecommendation({
    required double latitude,
    required double longitude,
    String? areaName,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current_weather': 'true',
      'timezone': 'auto',
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw StateError('Open-Meteo 호출에 실패했습니다. (${response.statusCode})');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final currentWeather = json['current_weather'] as Map<String, dynamic>?;
    if (currentWeather == null) {
      throw StateError('Open-Meteo 응답에 current_weather가 없습니다.');
    }

    final temperature = (currentWeather['temperature'] as num).toDouble();
    final weatherCode = (currentWeather['weathercode'] as num?)?.toInt() ?? 0;

    final suggestions = _buildOutfitSuggestions(temperature);

    return Recommendation(
      area: areaName ?? '현재 위치',
      temperature: temperature,
      weatherIcon: _mapWeatherCodeToIcon(weatherCode),
      tops: suggestions.tops,
      bottoms: suggestions.bottoms,
      outerwear: suggestions.outerwear,
      shoes: suggestions.shoes,
      accessories: suggestions.accessories,
    );
  }

  ({
    List<RecommendationItem> tops,
    List<RecommendationItem> bottoms,
    List<RecommendationItem> outerwear,
    List<RecommendationItem> shoes,
    List<RecommendationItem> accessories,
  }) _buildOutfitSuggestions(double temperature) {
    if (temperature >= 26) {
      return (
        tops: [RecommendationItem(label: '👕 반팔티', probability: 0.8)],
        bottoms: [RecommendationItem(label: '🩳 반바지', probability: 0.7)],
        outerwear: const [],
        shoes: [RecommendationItem(label: '🩴 샌들', probability: 0.6)],
        accessories: [RecommendationItem(label: '🕶️ 선글라스', probability: 0.5)],
      );
    }

    if (temperature >= 18) {
      return (
        tops: [RecommendationItem(label: '🧥 니트', probability: 0.6)],
        bottoms: [RecommendationItem(label: '👖 청바지', probability: 0.65)],
        outerwear: [RecommendationItem(label: '🧥 자켓', probability: 0.4)],
        shoes: [RecommendationItem(label: '👟 스니커즈', probability: 0.7)],
        accessories: [RecommendationItem(label: '🧢 모자', probability: 0.3)],
      );
    }

    if (temperature >= 10) {
      return (
        tops: [RecommendationItem(label: '🧥 셔츠', probability: 0.5)],
        bottoms: [RecommendationItem(label: '🧶 면바지', probability: 0.5)],
        outerwear: [RecommendationItem(label: '🧥 트렌치코트', probability: 0.6)],
        shoes: [RecommendationItem(label: '👟 스니커즈', probability: 0.55)],
        accessories: [RecommendationItem(label: '🧣 머플러', probability: 0.35)],
      );
    }

    return (
      tops: [RecommendationItem(label: '🧥 두꺼운 니트', probability: 0.7)],
      bottoms: [RecommendationItem(label: '🧤 기모바지', probability: 0.6)],
      outerwear: [RecommendationItem(label: '🧥 패딩', probability: 0.8)],
      shoes: [RecommendationItem(label: '🥾 부츠', probability: 0.65)],
      accessories: [RecommendationItem(label: '🧤 장갑', probability: 0.5)],
    );
  }

  String _mapWeatherCodeToIcon(int weatherCode) {
    if (weatherCode == 0) return 'sunny';
    if (weatherCode <= 3) return 'partly_cloudy';
    if (weatherCode <= 48) return 'fog';
    if (weatherCode <= 67) return 'rain';
    if (weatherCode <= 77) return 'snow';
    if (weatherCode <= 82) return 'heavy_rain';
    if (weatherCode <= 86) return 'heavy_snow';
    if (weatherCode <= 99) return 'storm';
    return 'unknown';
  }
}
