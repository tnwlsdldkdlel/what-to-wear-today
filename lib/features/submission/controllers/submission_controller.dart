import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/models/outfit_submission.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/device_service.dart';
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
    required DeviceService deviceService,
  })  : _authService = authService,
        _supabaseService = supabaseService,
        _locationService = locationService,
        _deviceService = deviceService;

  final AuthService _authService;
  final SupabaseService _supabaseService;
  final LocationService _locationService;
  final DeviceService _deviceService;

  final RxString selectedTop = ''.obs;
  final RxString selectedBottom = ''.obs;
  final RxString selectedOuter = ''.obs;
  final RxString selectedShoes = ''.obs;
  final RxList<String> selectedAccessories = <String>[].obs;
  final RxBool isSubmitting = false.obs;
  final RxString submitMessage = ''.obs;

  final List<ClothingOption> tops = const [
    ClothingOption(label: '반팔티', assetPath: 'assets/images/tops/tshirt.svg'),
    ClothingOption(label: '후드티', assetPath: 'assets/images/tops/hood.svg'),
    ClothingOption(label: '긴팔티', assetPath: 'assets/images/tops/sleeves.svg'),
    ClothingOption(label: '셔츠', assetPath: 'assets/images/tops/shirt.svg'),
    ClothingOption(label: '니트', assetPath: 'assets/images/tops/knit.svg'),
    ClothingOption(label: '맨투맨', assetPath: 'assets/images/tops/man.svg'),
  ];

  final List<ClothingOption> bottoms = const [
    ClothingOption(label: '긴바지', assetPath: 'assets/images/bottoms/pants.svg'),
    ClothingOption(label: '반바지', assetPath: 'assets/images/bottoms/shorts.svg'),
    ClothingOption(label: '치마', assetPath: 'assets/images/bottoms/skirt.svg'),
  ];

  final List<ClothingOption> outers = const [
    ClothingOption(label: '후드집업', assetPath: 'assets/images/outers/zip-up.svg'),
    ClothingOption(
        label: '가디건', assetPath: 'assets/images/outers/cardigan.svg'),
    ClothingOption(label: '코트', assetPath: 'assets/images/outers/coat.svg'),
    ClothingOption(label: '패딩', assetPath: 'assets/images/outers/padding.svg'),
  ];

  final List<ClothingOption> shoes = const [
    ClothingOption(label: '운동화', assetPath: 'assets/images/shoes/sneakers.svg'),
    ClothingOption(label: '장화', assetPath: 'assets/images/shoes/boots.svg'),
    ClothingOption(label: '샌들', assetPath: 'assets/images/shoes/flip.svg'),
    ClothingOption(label: '어그부츠', assetPath: 'assets/images/shoes/agg.svg'),
  ];

  final List<ClothingOption> accessories = const [
    ClothingOption(
        label: '목도리', assetPath: 'assets/images/accessories/muffler.svg'),
    ClothingOption(label: '모자', assetPath: 'assets/images/accessories/hat.svg'),
    ClothingOption(
        label: '우산', assetPath: 'assets/images/accessories/umbrella.svg'),
    ClothingOption(
        label: '장갑', assetPath: 'assets/images/accessories/gloves.svg'),
  ];

  void selectTop(String value) async {
    selectedTop.value = value;
    await Future.delayed(const Duration(milliseconds: 300));
    Get.toNamed(AppRoutes.submissionBottom);
  }

  void selectBottom(String value) async {
    selectedBottom.value = value;
    await Future.delayed(const Duration(milliseconds: 300));
    Get.toNamed(AppRoutes.submissionOuter);
  }

  void selectOuter(String value) async {
    if (selectedOuter.value == value) {
      selectedOuter.value = '';
    } else {
      selectedOuter.value = value;
    }
    await Future.delayed(const Duration(milliseconds: 300));
    Get.toNamed(AppRoutes.submissionShoes);
  }

  void skipOuter() {
    selectedOuter.value = '';
    Get.toNamed(AppRoutes.submissionShoes);
  }

  void selectShoes(String value) async {
    selectedShoes.value = value;
    await Future.delayed(const Duration(milliseconds: 300));
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
    Get.toNamed(AppRoutes.submissionReview);
  }

  void proceedFromAccessories() {
    Get.toNamed(AppRoutes.submissionReview);
  }

  Future<bool> confirmCancel() async {
    final result = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('등록을 취소하겠어요?'),
            content: const Text('지금까지 선택한 내용이 모두 사라집니다.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text('취소'),
              ),
              FilledButton(
                onPressed: () => Get.back(result: false),
                child: const Text('계속 작성'),
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
      final position = await _locationService.getCurrentPosition();
      final deviceId = await _deviceService.getDeviceId();
      final cityName = await _locationService.getCityName(position);
      final submission = _buildSubmission(
        position: position,
        deviceId: deviceId,
        cityName: cityName,
      );
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
      selectedShoes.value.isNotEmpty;

  OutfitSubmission _buildSubmission({
    required Position position,
    required String deviceId,
    required String cityName,
  }) {
    return OutfitSubmission(
      deviceId: deviceId,
      cityName: cityName,
      latitude: position.latitude,
      longitude: position.longitude,
      top: selectedTop.value,
      bottom: selectedBottom.value,
      outerwear: selectedOuter.value.isEmpty ? null : selectedOuter.value,
      shoes: selectedShoes.value,
      accessories:
          selectedAccessories.isEmpty ? null : selectedAccessories.toList(),
      reportedAt: DateTime.now(),
    );
  }

  void _resetForm() {
    selectedTop.value = '';
    selectedBottom.value = '';
    selectedOuter.value = '';
    selectedShoes.value = '';
    selectedAccessories.clear();
    submitMessage.value = '';
  }

  String get topLabel => selectedTop.value;

  String get bottomLabel => selectedBottom.value;

  String get outerLabel =>
      selectedOuter.value.isEmpty ? '선택 안 함' : selectedOuter.value;

  String get shoesLabel => selectedShoes.value;

  String get accessoriesLabel =>
      selectedAccessories.isEmpty ? '선택 안 함' : selectedAccessories.join(', ');

  ClothingOption? get selectedTopOption => selectedTop.value.isEmpty
      ? null
      : tops.firstWhere((item) => item.label == selectedTop.value);

  ClothingOption? get selectedBottomOption => selectedBottom.value.isEmpty
      ? null
      : bottoms.firstWhere((item) => item.label == selectedBottom.value);

  ClothingOption? get selectedOuterOption => selectedOuter.value.isEmpty
      ? null
      : outers.firstWhere((item) => item.label == selectedOuter.value);

  ClothingOption? get selectedShoesOption => selectedShoes.value.isEmpty
      ? null
      : shoes.firstWhere((item) => item.label == selectedShoes.value);

  List<ClothingOption> get selectedAccessoriesOptions => selectedAccessories
      .map((label) => accessories.firstWhere((item) => item.label == label))
      .toList();
}
