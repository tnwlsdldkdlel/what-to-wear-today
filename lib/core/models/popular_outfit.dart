/// 특정 지역의 인기 착장 조합
class PopularOutfit {
  const PopularOutfit({
    required this.top,
    required this.bottom,
    this.outerwear,
    this.shoes,
    this.accessories,
    required this.count,
    required this.cityName,
  });

  /// 상의 이름
  final String top;

  /// 하의 이름
  final String bottom;

  /// 아우터 이름 (선택사항)
  final String? outerwear;

  /// 신발 이름 (선택사항)
  final String? shoes;

  /// 악세서리 목록 (선택사항)
  final List<String>? accessories;

  /// 해당 조합을 입은 사용자 수
  final int count;

  /// 지역명
  final String cityName;

  /// 추천 문구 생성
  String buildRecommendationMessage() {
    final items = <String>[top, bottom];

    if (outerwear != null && outerwear!.isNotEmpty) {
      items.add(outerwear!);
    }

    if (shoes != null && shoes!.isNotEmpty) {
      items.add(shoes!);
    }

    if (accessories != null && accessories!.isNotEmpty) {
      items.addAll(accessories!);
    }

    // 모든 아이템을 콤마로 연결
    final itemsText = items.join(', ');

    return '$cityName 유저들이 가장 많이 입은 착장은 $itemsText 조합이에요! 👍';
  }

  factory PopularOutfit.fromJson(Map<String, dynamic> json) {
    return PopularOutfit(
      top: json['top'] as String,
      bottom: json['bottom'] as String,
      outerwear: json['outerwear'] as String?,
      shoes: json['shoes'] as String?,
      accessories: json['accessories'] != null
          ? List<String>.from(json['accessories'] as List)
          : null,
      count: json['count'] as int,
      cityName: json['city_name'] as String,
    );
  }
}
