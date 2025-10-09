class Recommendation {
  Recommendation({
    required this.area,
    required this.temperature,
    required this.weatherIcon,
    required this.tops,
    required this.bottoms,
    required this.outerwear,
    required this.shoes,
    required this.accessories,
  });

  final String area;
  final double temperature;
  final String weatherIcon;
  final List<RecommendationItem> tops;
  final List<RecommendationItem> bottoms;
  final List<RecommendationItem> outerwear;
  final List<RecommendationItem> shoes;
  final List<RecommendationItem> accessories;

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    List<RecommendationItem> _parseList(String key) {
      final list = json[key] as List<dynamic>? ?? [];
      return list
          .map((raw) => RecommendationItem.fromJson(raw as Map<String, dynamic>))
          .toList();
    }

    return Recommendation(
      area: json['recommendation_area'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      weatherIcon: json['weather_icon'] as String,
      tops: _parseList('tops'),
      bottoms: _parseList('bottoms'),
      outerwear: _parseList('outerwear'),
      shoes: _parseList('shoes'),
      accessories: _parseList('accessories'),
    );
  }

  String buildSummarySentence() {
    final mainItems = <String>[
      tops.isNotEmpty ? tops.first.label : '',
      bottoms.isNotEmpty ? bottoms.first.label : '',
      outerwear.isNotEmpty ? outerwear.first.label : '',
      shoes.isNotEmpty ? shoes.first.label : '',
    ].where((item) => item.isNotEmpty).toList();

    final acc = accessories.isNotEmpty ? '와 ${accessories.first.label}' : '';
    final clothing = mainItems.join(', ');
    return '$area에서는 $clothing$acc 착장을 많이 입고 있어요.';
  }
}

class RecommendationItem {
  RecommendationItem({
    required this.label,
    required this.probability,
  });

  final String label;
  final double probability;

  factory RecommendationItem.fromJson(Map<String, dynamic> json) => RecommendationItem(
        label: json['label'] as String,
        probability: (json['probability'] as num).toDouble(),
      );
}
