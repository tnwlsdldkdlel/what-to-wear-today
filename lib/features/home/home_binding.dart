import 'package:get/get.dart';

import '../../core/services/location_service.dart';
import '../../core/services/recommendation_service.dart';
import '../../features/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationService>(() => LocationService());
    Get.lazyPut<RecommendationService>(() => RecommendationService());
    Get.put<HomeController>(HomeController(
      locationService: Get.find<LocationService>(),
      recommendationService: Get.find<RecommendationService>(),
    ));
  }
}
