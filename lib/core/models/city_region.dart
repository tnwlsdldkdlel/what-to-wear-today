/// 한국의 시/도 정보 모델
class CityRegion {
  const CityRegion({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  /// 시/도 이름 (예: '서울특별시', '부산광역시')
  final String name;

  /// 대표 좌표 - 위도
  final double latitude;

  /// 대표 좌표 - 경도
  final double longitude;

  /// 한국의 모든 시/도 목록 (17개)
  static const List<CityRegion> all = [
    CityRegion(
      name: '서울특별시',
      latitude: 37.5665,
      longitude: 126.9780,
    ),
    CityRegion(
      name: '부산광역시',
      latitude: 35.1796,
      longitude: 129.0756,
    ),
    CityRegion(
      name: '대구광역시',
      latitude: 35.8714,
      longitude: 128.6014,
    ),
    CityRegion(
      name: '인천광역시',
      latitude: 37.4563,
      longitude: 126.7052,
    ),
    CityRegion(
      name: '광주광역시',
      latitude: 35.1595,
      longitude: 126.8526,
    ),
    CityRegion(
      name: '대전광역시',
      latitude: 36.3504,
      longitude: 127.3845,
    ),
    CityRegion(
      name: '울산광역시',
      latitude: 35.5384,
      longitude: 129.3114,
    ),
    CityRegion(
      name: '세종특별자치시',
      latitude: 36.4801,
      longitude: 127.2890,
    ),
    CityRegion(
      name: '경기도',
      latitude: 37.4138,
      longitude: 127.5183,
    ),
    CityRegion(
      name: '강원특별자치도',
      latitude: 37.8228,
      longitude: 128.1555,
    ),
    CityRegion(
      name: '충청북도',
      latitude: 36.6357,
      longitude: 127.4913,
    ),
    CityRegion(
      name: '충청남도',
      latitude: 36.5184,
      longitude: 126.8000,
    ),
    CityRegion(
      name: '전북특별자치도',
      latitude: 35.7175,
      longitude: 127.1530,
    ),
    CityRegion(
      name: '전라남도',
      latitude: 34.8161,
      longitude: 126.4629,
    ),
    CityRegion(
      name: '경상북도',
      latitude: 36.4919,
      longitude: 128.8889,
    ),
    CityRegion(
      name: '경상남도',
      latitude: 35.4606,
      longitude: 128.2132,
    ),
    CityRegion(
      name: '제주특별자치도',
      latitude: 33.4890,
      longitude: 126.4983,
    ),
  ];

  /// 검색어로 시/도 필터링
  static List<CityRegion> search(String query) {
    if (query.isEmpty) {
      return all;
    }
    final normalizedQuery = query.toLowerCase().trim();
    return all.where((region) {
      return region.name.toLowerCase().contains(normalizedQuery);
    }).toList();
  }
}
