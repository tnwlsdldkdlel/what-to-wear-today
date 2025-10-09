import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/models/outfit_submission.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/supabase_service.dart';

class SubmissionController extends GetxController {
  SubmissionController({
    required AuthService authService,
    required SupabaseService supabaseService,
    required LocationService locationService,
  })  : _authService = authService,
        _supabaseService = supabaseService,
        _locationService = locationService;

  final AuthService _authService;
  final SupabaseService _supabaseService;
  final LocationService _locationService;

  final RxString selectedTop = ''.obs;
  final RxString selectedBottom = ''.obs;
  final RxString selectedOuter = ''.obs;
  final RxString selectedShoes = ''.obs;
  final RxList<String> selectedAccessories = <String>[].obs;
  final Rx<ComfortLevel?> selectedComfort = Rx<ComfortLevel?>(null);
  final RxBool isSubmitting = false.obs;
  final RxString submitMessage = ''.obs;

  final tops = const [
    '👕 반팔티',
    '👔 셔츠',
    '🧥 니트',
    '👚 블라우스',
  ];

  final bottoms = const [
    '👖 청바지',
    '🩳 반바지',
    '🩲 슬랙스',
    '👗 원피스',
  ];

  final outers = const [
    '🧥 자켓',
    '🧥 코트',
    '🧢 후드집업',
    '🧥 패딩',
  ];

  final shoes = const [
    '👟 스니커즈',
    '👞 구두',
    '🥾 부츠',
    '🩴 샌들',
  ];

  final accessories = const [
    '🧣 머플러',
    '🧤 장갑',
    '🧢 모자',
    '🕶️ 선글라스',
  ];

  void toggleAccessory(String accessory) {
    if (selectedAccessories.contains(accessory)) {
      selectedAccessories.remove(accessory);
    } else {
      selectedAccessories.add(accessory);
    }
  }

  Future<void> submit() async {
    if (!_canSubmit) {
      submitMessage.value = '모든 필수 항목을 선택해주세요.';
      return;
    }

    isSubmitting.value = true;
    submitMessage.value = '';
    try {
      await _authService.ensureSession();
      final position = await _locationService.getCurrentPosition();
      final submission = _buildSubmission(position);
      await _supabaseService.submitOutfit(submission);
      submitMessage.value = '제출이 완료되었습니다!';
      _resetForm();
    } catch (error) {
      submitMessage.value = '제출에 실패했습니다: $error';
    } finally {
      isSubmitting.value = false;
    }
  }

  bool get _canSubmit =>
      selectedTop.value.isNotEmpty &&
      selectedBottom.value.isNotEmpty &&
      selectedShoes.value.isNotEmpty &&
      selectedComfort.value != null;

  OutfitSubmission _buildSubmission(Position position) {
    return OutfitSubmission(
      latitude: position.latitude,
      longitude: position.longitude,
      top: selectedTop.value,
      bottom: selectedBottom.value,
      outerwear: selectedOuter.value.isEmpty ? null : selectedOuter.value,
      shoes: selectedShoes.value,
      accessories: selectedAccessories.isEmpty ? null : selectedAccessories.toList(),
      comfort: selectedComfort.value!,
      reportedAt: DateTime.now(),
      userId: _authService.currentUserId,
    );
  }

  void _resetForm() {
    selectedTop.value = '';
    selectedBottom.value = '';
    selectedOuter.value = '';
    selectedShoes.value = '';
    selectedAccessories.clear();
    selectedComfort.value = null;
  }
}
