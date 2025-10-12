import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/models/outfit_submission.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/supabase_service.dart';

class ClothingOption {
  const ClothingOption({required this.label, required this.assetPath});

  final String label;
  final String assetPath;
}

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

  final List<ClothingOption> tops = const [
    ClothingOption(label: '반팔티', assetPath: 'assets/images/tops/tshirt.svg'),
    ClothingOption(label: '셔츠', assetPath: 'assets/images/tops/shirt.png'),
    ClothingOption(label: '니트', assetPath: 'assets/images/tops/knit.png'),
    ClothingOption(label: '블라우스', assetPath: 'assets/images/tops/blouse.png'),
  ];

  final List<ClothingOption> bottoms = const [
    ClothingOption(label: '청바지', assetPath: 'assets/images/bottoms/jeans.png'),
    ClothingOption(label: '반바지', assetPath: 'assets/images/bottoms/shorts.png'),
    ClothingOption(label: '슬랙스', assetPath: 'assets/images/bottoms/slacks.png'),
    ClothingOption(label: '원피스', assetPath: 'assets/images/bottoms/dress.png'),
  ];

  final List<ClothingOption> outers = const [
    ClothingOption(label: '자켓', assetPath: 'assets/images/outers/jacket.png'),
    ClothingOption(label: '코트', assetPath: 'assets/images/outers/coat.png'),
    ClothingOption(label: '후드집업', assetPath: 'assets/images/outers/hoodie.png'),
    ClothingOption(label: '패딩', assetPath: 'assets/images/outers/padding.png'),
  ];

  final List<ClothingOption> shoes = const [
    ClothingOption(
        label: '스니커즈', assetPath: 'assets/images/shoes/sneakers.png'),
    ClothingOption(label: '구두', assetPath: 'assets/images/shoes/loafers.png'),
    ClothingOption(label: '부츠', assetPath: 'assets/images/shoes/boots.png'),
    ClothingOption(label: '샌들', assetPath: 'assets/images/shoes/sandals.png'),
  ];

  final List<ClothingOption> accessories = const [
    ClothingOption(
        label: '머플러', assetPath: 'assets/images/accessories/scarf.png'),
    ClothingOption(
        label: '장갑', assetPath: 'assets/images/accessories/gloves.png'),
    ClothingOption(label: '모자', assetPath: 'assets/images/accessories/hat.png'),
    ClothingOption(
        label: '선글라스', assetPath: 'assets/images/accessories/sunglasses.png'),
  ];

  void selectTop(String value) {
    selectedTop.value = value;
    Get.toNamed(AppRoutes.submissionBottom);
  }

  void selectBottom(String value) {
    selectedBottom.value = value;
    Get.toNamed(AppRoutes.submissionOuter);
  }

  void selectOuter(String value) {
    if (selectedOuter.value == value) {
      selectedOuter.value = '';
    } else {
      selectedOuter.value = value;
    }
    Get.toNamed(AppRoutes.submissionShoes);
  }

  void skipOuter() {
    selectedOuter.value = '';
    Get.toNamed(AppRoutes.submissionShoes);
  }

  void selectShoes(String value) {
    selectedShoes.value = value;
    Get.toNamed(AppRoutes.submissionAccessories);
  }

  void toggleAccessory(String accessory) {
    if (selectedAccessories.contains(accessory)) {
      selectedAccessories.remove(accessory);
    } else {
      selectedAccessories.add(accessory);
    }
  }

  void skipAccessory() {
    selectedAccessories.clear();
    Get.toNamed(AppRoutes.submissionComfort);
  }

  void proceedFromAccessories() {
    Get.toNamed(AppRoutes.submissionComfort);
  }

  void selectComfort(ComfortLevel level) {
    selectedComfort.value = level;
    Get.toNamed(AppRoutes.submissionReview);
  }

  Future<bool> confirmCancel() async {
    final result = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('등록을 취소하겠어요?'),
            content: const Text('지금까지 선택한 내용이 모두 사라집니다.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('계속 작성'),
              ),
              FilledButton(
                onPressed: () => Get.back(result: true),
                child: const Text('취소'),
              ),
            ],
          ),
        ) ??
        false;

    if (result) {
      _resetForm();
    }
    return result;
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
      Get.offAllNamed(AppRoutes.home);
      Get.snackbar('제출 완료', '추천에 반영되기까지 잠시만 기다려주세요.');
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
      accessories:
          selectedAccessories.isEmpty ? null : selectedAccessories.toList(),
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
    submitMessage.value = '';
  }

  String get topLabel => selectedTop.value;

  String get bottomLabel => selectedBottom.value;

  String get outerLabel =>
      selectedOuter.value.isEmpty ? '선택 안 함' : selectedOuter.value;

  String get shoesLabel => selectedShoes.value;

  String get accessoriesLabel =>
      selectedAccessories.isEmpty ? '선택 안 함' : selectedAccessories.join(', ');

  String get comfortLabel {
    switch (selectedComfort.value) {
      case ComfortLevel.hot:
        return '덥다';
      case ComfortLevel.justRight:
        return '딱 좋아요';
      case ComfortLevel.cold:
        return '춥다';
      default:
        return '미선택';
    }
  }
}
