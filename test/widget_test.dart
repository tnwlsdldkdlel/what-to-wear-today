import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import 'package:what_to_wear_today/app/app.dart';
import 'package:what_to_wear_today/core/models/outfit_submission.dart';
import 'package:what_to_wear_today/core/models/recommendation.dart';
import 'package:what_to_wear_today/core/services/auth_service.dart';
import 'package:what_to_wear_today/core/services/location_service.dart';
import 'package:what_to_wear_today/core/services/recommendation_service.dart';
import 'package:what_to_wear_today/core/services/supabase_service.dart';
import 'package:what_to_wear_today/features/home/controllers/home_controller.dart';
import 'package:what_to_wear_today/features/home/views/home_view.dart';
import 'package:what_to_wear_today/features/submission/controllers/submission_controller.dart';

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
    Get.put<AuthService>(_FakeAuthService());
    Get.put<SupabaseService>(_FakeSupabaseService());
    Get.put<SubmissionController>(SubmissionController(
      authService: Get.find<AuthService>(),
      supabaseService: Get.find<SupabaseService>(),
      locationService: Get.find<LocationService>(),
    ));
    Get.put<HomeController>(HomeController(
      locationService: Get.find<LocationService>(),
      recommendationService: Get.find<RecommendationService>(),
    ));

    await tester.pumpWidget(const OutfitApp());
    await tester.pump();

    expect(find.byType(HomeView), findsOneWidget);
  });

  testWidgets('착장 제출 플로우가 단계별 화면으로 진행된다', (tester) async {
    Get.put<LocationService>(_FakeLocationService());
    Get.put<RecommendationService>(_FakeRecommendationService());
    Get.put<AuthService>(_FakeAuthService());
    Get.put<SupabaseService>(_FakeSupabaseService());
    Get.put<SubmissionController>(SubmissionController(
      authService: Get.find<AuthService>(),
      supabaseService: Get.find<SupabaseService>(),
      locationService: Get.find<LocationService>(),
    ));
    Get.put<HomeController>(HomeController(
      locationService: Get.find<LocationService>(),
      recommendationService: Get.find<RecommendationService>(),
    ));

    await tester.pumpWidget(const OutfitApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('내 착장 공유하기'));
    await tester.pumpAndSettle();

    expect(find.text('1 · 상의'), findsOneWidget);
    await tester.tap(find.text('👕 반팔티'));
    await tester.pumpAndSettle();

    expect(find.text('2 · 하의'), findsOneWidget);
    await tester.tap(find.text('👖 청바지'));
    await tester.pumpAndSettle();

    expect(find.text('3 · 아우터'), findsOneWidget);
    await tester.tap(find.text('아우터 건너뛰기'));
    await tester.pumpAndSettle();

    expect(find.text('4 · 신발'), findsOneWidget);
    await tester.tap(find.text('👟 스니커즈'));
    await tester.pumpAndSettle();

    expect(find.text('5 · 액세서리'), findsOneWidget);
    await tester.tap(find.text('🧢 모자'));
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();

    expect(find.text('6 · 체감 온도'), findsOneWidget);
    await tester.tap(find.text('딱 좋아요'));
    await tester.pumpAndSettle();

    expect(find.text('제출 전 확인'), findsOneWidget);
    expect(find.text('제출하기'), findsOneWidget);
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

class _FakeAuthService extends AuthService {
  @override
  Future<void> ensureSession() async {}

  @override
  String? get currentUserId => 'test-user';
}

class _FakeSupabaseService extends SupabaseService {
  @override
  Future<void> submitOutfit(OutfitSubmission submission) async {}
}
