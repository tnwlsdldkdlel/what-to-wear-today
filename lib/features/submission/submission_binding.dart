import 'package:get/get.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/location_service.dart';
import '../../core/services/supabase_service.dart';
import '../../features/submission/controllers/submission_controller.dart';

class SubmissionBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SupabaseService>()) {
      Get.lazyPut<SupabaseService>(() => SupabaseService());
    }
    if (!Get.isRegistered<LocationService>()) {
      Get.lazyPut<LocationService>(() => LocationService());
    }
    if (!Get.isRegistered<AuthService>()) {
      Get.lazyPut<AuthService>(() => AuthService());
    }
    if (!Get.isRegistered<SubmissionController>()) {
      Get.put<SubmissionController>(SubmissionController(
        authService: Get.find<AuthService>(),
        supabaseService: Get.find<SupabaseService>(),
        locationService: Get.find<LocationService>(),
      ));
    }
  }
}
