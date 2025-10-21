import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/recommendation.dart';
import 'supabase_service.dart';

class RecommendationService {
  RecommendationService({required SupabaseService supabaseService})
      : _supabaseService = supabaseService;

  final SupabaseService _supabaseService;

  static const _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<Recommendation> fetchRecommendation({
    required double latitude,
    required double longitude,
    String? areaName,
    String? cityName,
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

    // 실제 착장 데이터 기반 추천 생성
    final suggestions = cityName != null
        ? await _buildOutfitSuggestionsFromData(cityName, temperature)
        : _buildFallbackSuggestions(temperature);

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

  /// 실제 착장 데이터 기반 추천 생성
  Future<
      ({
        List<RecommendationItem> tops,
        List<RecommendationItem> bottoms,
        List<RecommendationItem> outerwear,
        List<RecommendationItem> shoes,
        List<RecommendationItem> accessories,
      })> _buildOutfitSuggestionsFromData(
      String cityName, double temperature) async {
    final outfits = await _supabaseService.getOutfitsByTemperature(
      cityName: cityName,
      temperature: temperature,
    );

    if (outfits.isEmpty) {
      return _buildFallbackSuggestions(temperature);
    }

    // 각 카테고리별 빈도 집계
    final topCounts = <String, int>{};
    final bottomCounts = <String, int>{};
    final outerwearCounts = <String, int>{};
    final shoesCounts = <String, int>{};
    final accessoriesCounts = <String, int>{};

    for (final outfit in outfits) {
      final top = outfit['top'] as String?;
      final bottom = outfit['bottom'] as String?;
      final outerwear = outfit['outerwear'] as String?;
      final shoes = outfit['shoes'] as String?;
      final accessories = outfit['accessories'] as List<dynamic>?;

      if (top != null) topCounts[top] = (topCounts[top] ?? 0) + 1;
      if (bottom != null) bottomCounts[bottom] = (bottomCounts[bottom] ?? 0) + 1;
      if (outerwear != null && outerwear.isNotEmpty) {
        outerwearCounts[outerwear] = (outerwearCounts[outerwear] ?? 0) + 1;
      }
      if (shoes != null && shoes.isNotEmpty) {
        shoesCounts[shoes] = (shoesCounts[shoes] ?? 0) + 1;
      }
      if (accessories != null) {
        for (final acc in accessories) {
          final accStr = acc as String;
          accessoriesCounts[accStr] = (accessoriesCounts[accStr] ?? 0) + 1;
        }
      }
    }

    final totalCount = outfits.length;

    return (
      tops: _buildRecommendationItems(topCounts, totalCount),
      bottoms: _buildRecommendationItems(bottomCounts, totalCount),
      outerwear: _buildRecommendationItems(outerwearCounts, totalCount),
      shoes: _buildRecommendationItems(shoesCounts, totalCount),
      accessories: _buildRecommendationItems(accessoriesCounts, totalCount),
    );
  }

  /// 빈도 맵을 추천 아이템 리스트로 변환
  List<RecommendationItem> _buildRecommendationItems(
      Map<String, int> counts, int total) {
    if (counts.isEmpty || total == 0) return [];

    final items = counts.entries
        .map((e) => RecommendationItem(
              label: e.key,
              probability: e.value / total,
            ))
        .toList()
      ..sort((a, b) => b.probability.compareTo(a.probability));

    // 상위 5개만 반환
    return items.take(5).toList();
  }

  /// 데이터가 없을 때 폴백 추천
  ({
    List<RecommendationItem> tops,
    List<RecommendationItem> bottoms,
    List<RecommendationItem> outerwear,
    List<RecommendationItem> shoes,
    List<RecommendationItem> accessories,
  }) _buildFallbackSuggestions(double temperature) {
    if (temperature >= 26) {
      return (
        tops: [RecommendationItem(label: '반팔티', probability: 0.8)],
        bottoms: [RecommendationItem(label: '반바지', probability: 0.7)],
        outerwear: const [],
        shoes: [RecommendationItem(label: '샌들', probability: 0.6)],
        accessories: const [],
      );
    }

    if (temperature >= 18) {
      return (
        tops: [RecommendationItem(label: '긴팔티', probability: 0.7)],
        bottoms: [RecommendationItem(label: '긴바지', probability: 0.8)],
        outerwear: [RecommendationItem(label: '가디건', probability: 0.4)],
        shoes: [RecommendationItem(label: '운동화', probability: 0.7)],
        accessories: const [],
      );
    }

    if (temperature >= 10) {
      return (
        tops: [RecommendationItem(label: '니트', probability: 0.6)],
        bottoms: [RecommendationItem(label: '긴바지', probability: 0.7)],
        outerwear: [RecommendationItem(label: '코트', probability: 0.6)],
        shoes: [RecommendationItem(label: '운동화', probability: 0.6)],
        accessories: [RecommendationItem(label: '목도리', probability: 0.4)],
      );
    }

    return (
      tops: [RecommendationItem(label: '니트', probability: 0.7)],
      bottoms: [RecommendationItem(label: '긴바지', probability: 0.8)],
      outerwear: [RecommendationItem(label: '패딩', probability: 0.9)],
      shoes: [RecommendationItem(label: '부츠', probability: 0.6)],
      accessories: [RecommendationItem(label: '장갑', probability: 0.5)],
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
