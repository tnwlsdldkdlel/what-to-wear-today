import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/models/city_region.dart';
import '../../../core/models/recommendation.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/recommendation_service.dart';

class HomeController extends GetxController {
  HomeController({
    required LocationService locationService,
    required RecommendationService recommendationService,
  })  : _locationService = locationService,
        _recommendationService = recommendationService;

  final LocationService _locationService;
  final RecommendationService _recommendationService;

  final RxBool isLoading = false.obs;
  final Rxn<Recommendation> recommendation = Rxn<Recommendation>();
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

      if (selectedRegion.value != null) {
        // 선택된 지역 사용
        latitude = selectedRegion.value!.latitude;
        longitude = selectedRegion.value!.longitude;
        area = selectedRegion.value!.name;
      } else {
        // GPS 위치 사용
        final position = await _locationService.getCurrentPosition();
        latitude = position.latitude;
        longitude = position.longitude;
        area = await _locationService.resolvePlacemark(position);
      }

      areaLabel.value = area;
      final data = await _recommendationService.fetchRecommendation(
        latitude: latitude,
        longitude: longitude,
        areaName: area,
      );
      recommendation.value = data;
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
