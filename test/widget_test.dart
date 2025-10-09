import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import 'package:what_to_wear_today/app/app.dart';
import 'package:what_to_wear_today/core/models/recommendation.dart';
import 'package:what_to_wear_today/core/services/location_service.dart';
import 'package:what_to_wear_today/core/services/recommendation_service.dart';
import 'package:what_to_wear_today/features/home/controllers/home_controller.dart';
import 'package:what_to_wear_today/features/home/views/home_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
  });

  tearDown(() async {
    await Get.deleteAll(force: true);
  });

  testWidgets('홈 화면이 추천 문구와 공유 버튼을 표시한다', (tester) async {
    final locationService = _FakeLocationService();
    final recommendationService = _FakeRecommendationService();
    final controller = HomeController(
      locationService: locationService,
      recommendationService: recommendationService,
    );

    Get.put<HomeController>(controller);

    await tester.pumpWidget(const GetMaterialApp(home: HomeView()));
    await tester.pump();

    expect(find.text('오늘 뭐 입음?'), findsOneWidget);
    expect(find.text('서울 강남구'), findsOneWidget);
    expect(find.textContaining('니트'), findsOneWidget);
    expect(find.text('내 착장 공유하기'), findsOneWidget);
  });

  testWidgets('OutfitApp은 초기 라우트로 홈 화면을 연다', (tester) async {
    Get.put<LocationService>(_FakeLocationService());
    Get.put<RecommendationService>(_FakeRecommendationService());
    Get.put<HomeController>(HomeController(
      locationService: Get.find<LocationService>(),
      recommendationService: Get.find<RecommendationService>(),
    ));

    await tester.pumpWidget(const OutfitApp());
    await tester.pump();

    expect(find.byType(HomeView), findsOneWidget);
  });
}

class _FakeLocationService extends LocationService {
  @override
  Future<Position> getCurrentPosition() async => Position(
        longitude: 127.0276,
        latitude: 37.4979,
        timestamp: DateTime(2025, 10, 9),
        accuracy: 1,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        headingAccuracy: 0,
        altitudeAccuracy: 0,
        floor: 0,
        isMocked: true,
      );

  @override
  Future<String> resolvePlacemark(Position position) async => '서울 강남구';
}

class _FakeRecommendationService extends RecommendationService {
  @override
  Future<Recommendation> fetchRecommendation({
    required double latitude,
    required double longitude,
    String? areaName,
  }) async {
    return Recommendation(
      area: areaName ?? '서울 강남구',
      temperature: 23.4,
      weatherIcon: 'sunny',
      tops: [RecommendationItem(label: '🧥 니트', probability: 0.6)],
      bottoms: [RecommendationItem(label: '👖 청바지', probability: 0.55)],
      outerwear: [RecommendationItem(label: '🧥 자켓', probability: 0.2)],
      shoes: [RecommendationItem(label: '👟 스니커즈', probability: 0.7)],
      accessories: [RecommendationItem(label: '🧢 모자', probability: 0.4)],
    );
  }
}
