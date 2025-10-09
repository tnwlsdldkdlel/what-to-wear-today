import 'package:get/get.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/location_service.dart';
import '../../core/services/supabase_service.dart';
import '../../features/submission/controllers/submission_controller.dart';

class SubmissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupabaseService>(() => SupabaseService());
    Get.lazyPut<LocationService>(() => LocationService());
    Get.lazyPut<AuthService>(() => AuthService());
    Get.put<SubmissionController>(SubmissionController(
      authService: Get.find<AuthService>(),
      supabaseService: Get.find<SupabaseService>(),
      locationService: Get.find<LocationService>(),
    ));
  }
}
