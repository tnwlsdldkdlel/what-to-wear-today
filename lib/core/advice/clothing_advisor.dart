import '../models/user_preferences.dart';
import '../models/weather_models.dart';

class ClothingAdvice {
  ClothingAdvice({
    required this.headline,
    required this.layerLevel,
    required this.suggestions,
  });

  final String headline;
  final LayerLevel layerLevel;
  final List<String> suggestions;
}

class ClothingAdvisor {
  const ClothingAdvisor();

  ClothingAdvice buildAdvice({
    required WeatherSnapshot weather,
    required UserPreferences preferences,
  }) {
    final adjustedFeelsLike = _adjustedFeelsLike(
      weather.feelsLikeC,
      preferences.sensitivity,
    );

    final layerLevel = _layerForTemperature(adjustedFeelsLike);
    final headline = _headlineForLayer(layerLevel);
    final suggestions = _suggestionsFor(
      layerLevel: layerLevel,
      precipitationChance: weather.precipitationChance,
      windSpeedKph: weather.windSpeedKph,
    );

    return ClothingAdvice(
      headline: headline,
      layerLevel: layerLevel,
      suggestions: suggestions,
    );
  }

  double _adjustedFeelsLike(
    double feelsLike,
    TemperatureSensitivity sensitivity,
  ) {
    switch (sensitivity) {
      case TemperatureSensitivity.runsCold:
        return feelsLike - 2.5;
      case TemperatureSensitivity.runsHot:
        return feelsLike + 2.5;
      case TemperatureSensitivity.neutral:
        return feelsLike;
    }
  }

  LayerLevel _layerForTemperature(double feelsLike) {
    if (feelsLike <= 5) {
      return LayerLevel.heavier;
    }
    if (feelsLike <= 18) {
      return LayerLevel.regular;
    }
    return LayerLevel.lighter;
  }

  String _headlineForLayer(LayerLevel level) {
    return {
          LayerLevel.heavier: '두껍게 챙겨요',
          LayerLevel.regular: '딱 좋은 레이어',
          LayerLevel.lighter: '가볍게 입어도 좋아요',
        }[level] ?? '오늘 뭐 입을까?';
  }

  List<String> _suggestionsFor({
    required LayerLevel layerLevel,
    required double precipitationChance,
    required double windSpeedKph,
  }) {
    final baseLayers = {
      LayerLevel.heavier: [
        '패딩 또는 두꺼운 코트',
        '니트, 기모 후드티',
        '기모 바지 + 보온 이너',
      ],
      LayerLevel.regular: [
        '가벼운 코트나 자켓',
        '니트나 맨투맨',
        '긴바지(청바지, 슬랙스)',
      ],
      LayerLevel.lighter: [
        '얇은 셔츠나 티셔츠',
        '가벼운 가디건',
        '슬랙스나 치노, 원피스',
      ],
    };

    final items = [...?baseLayers[layerLevel]];

    if (precipitationChance >= 60) {
      items.addAll(['우산 챙기기', '방수 가능한 신발']);
    } else if (precipitationChance >= 30) {
      items.add('작은 우산 하나');
    }

    if (windSpeedKph >= 25) {
      items.add('바람막이나 목도리');
    }

    return items
        .where((item) => item.trim().isNotEmpty)
        .toList(growable: false);
  }
}
