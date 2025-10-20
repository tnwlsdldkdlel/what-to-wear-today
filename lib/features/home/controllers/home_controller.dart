import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/models/city_region.dart';
import '../../../core/models/popular_outfit.dart';
import '../../../core/models/recommendation.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/recommendation_service.dart';
import '../../../core/services/supabase_service.dart';

class HomeController extends GetxController {
  HomeController({
    required LocationService locationService,
    required RecommendationService recommendationService,
    required SupabaseService supabaseService,
  })  : _locationService = locationService,
        _recommendationService = recommendationService,
        _supabaseService = supabaseService;

  final LocationService _locationService;
  final RecommendationService _recommendationService;
  final SupabaseService _supabaseService;

  final RxBool isLoading = false.obs;
  final Rxn<Recommendation> recommendation = Rxn<Recommendation>();
  final Rxn<PopularOutfit> popularOutfit = Rxn<PopularOutfit>();
  final RxString areaLabel = ''.obs;
  final RxString errorMessage = ''.obs;

  // 선택된 지역 (null이면 GPS 위치 사용)
  final Rxn<CityRegion> selectedRegion = Rxn<CityRegion>();

  @override
  void onInit() {
    super.onInit();
    fetchRecommendation();
  }

  Future<void> fetchRecommendation() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final double latitude;
      final double longitude;
      final String area;
      final String cityName;

      if (selectedRegion.value != null) {
        // 선택된 지역 사용
        latitude = selectedRegion.value!.latitude;
        longitude = selectedRegion.value!.longitude;
        area = selectedRegion.value!.name;
        cityName = selectedRegion.value!.name;
      } else {
        // GPS 위치 사용
        final position = await _locationService.getCurrentPosition();
        latitude = position.latitude;
        longitude = position.longitude;
        area = await _locationService.resolvePlacemark(position);
        cityName = await _locationService.getCityName(position);
      }

      areaLabel.value = area;

      // 날씨 추천 조회
      final data = await _recommendationService.fetchRecommendation(
        latitude: latitude,
        longitude: longitude,
        areaName: area,
      );
      recommendation.value = data;

      // 인기 착장 조회
      final popular = await _supabaseService.getPopularOutfit(cityName);
      popularOutfit.value = popular;
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// 특정 지역 선택
  void selectRegion(CityRegion region) {
    selectedRegion.value = region;
    fetchRecommendation();
  }

  /// 현재 GPS 위치 사용
  void useCurrentLocation() {
    selectedRegion.value = null;
    fetchRecommendation();
  }
}
