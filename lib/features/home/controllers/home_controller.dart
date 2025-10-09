import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

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

  @override
  void onInit() {
    super.onInit();
    fetchRecommendation();
  }

  Future<void> fetchRecommendation() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final position = await _locationService.getCurrentPosition();
      final area = await _locationService.resolvePlacemark(position);
      areaLabel.value = area;
      final data = await _recommendationService.fetchRecommendation(
        latitude: position.latitude,
        longitude: position.longitude,
        areaName: area,
      );
      recommendation.value = data;
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
