import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../advice/clothing_advisor.dart';
import '../location/location_service.dart';
import '../models/user_preferences.dart';
import '../models/weather_models.dart';
import '../storage/preferences_storage.dart';
import '../weather_api/weather_api_client.dart';
import '../weather_api/weather_repository.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  return dio;
});

final weatherApiClientProvider = Provider<WeatherApiClient>((ref) {
  const apiKey = String.fromEnvironment('OPEN_WEATHER_API_KEY');
  return WeatherApiClient(
    dio: ref.watch(dioProvider),
    apiKey: apiKey.isEmpty ? null : apiKey,
  );
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final client = ref.watch(weatherApiClientProvider);
  return WeatherRepository(client);
});

final clothingAdvisorProvider = Provider<ClothingAdvisor>((ref) {
  return const ClothingAdvisor();
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return const LocationService();
});

final presetLocationsProvider = Provider<List<LocationPoint>>((ref) {
  return const [
    // 서울특별시
    LocationPoint(
      latitude: 37.5665,
      longitude: 126.9780,
      locality: '서울특별시 중구',
      city: '서울특별시',
      district: '중구',
    ),
    LocationPoint(
      latitude: 37.5172,
      longitude: 127.0473,
      locality: '서울특별시 강남구',
      city: '서울특별시',
      district: '강남구',
    ),
    LocationPoint(
      latitude: 37.5485,
      longitude: 126.9124,
      locality: '서울특별시 마포구',
      city: '서울특별시',
      district: '마포구',
    ),
    LocationPoint(
      latitude: 37.5785,
      longitude: 126.9873,
      locality: '서울특별시 종로구',
      city: '서울특별시',
      district: '종로구',
    ),
    // 수도권
    LocationPoint(
      latitude: 37.2636,
      longitude: 127.0286,
      locality: '경기도 수원시 영통구',
      city: '경기도 수원시',
      district: '영통구',
    ),
    LocationPoint(
      latitude: 37.3858,
      longitude: 127.1217,
      locality: '경기도 성남시 분당구',
      city: '경기도 성남시',
      district: '분당구',
    ),
    LocationPoint(
      latitude: 37.3943,
      longitude: 126.9568,
      locality: '경기도 안양시 동안구',
      city: '경기도 안양시',
      district: '동안구',
    ),
    LocationPoint(
      latitude: 37.3417,
      longitude: 126.8064,
      locality: '경기도 시흥시 정왕동',
      city: '경기도 시흥시',
      district: '정왕동',
    ),
    // 광역시
    LocationPoint(
      latitude: 35.1796,
      longitude: 129.0756,
      locality: '부산광역시 해운대구',
      city: '부산광역시',
      district: '해운대구',
    ),
    LocationPoint(
      latitude: 35.0945,
      longitude: 129.0360,
      locality: '부산광역시 사상구',
      city: '부산광역시',
      district: '사상구',
    ),
    LocationPoint(
      latitude: 35.8714,
      longitude: 128.6014,
      locality: '대구광역시 중구',
      city: '대구광역시',
      district: '중구',
    ),
    LocationPoint(
      latitude: 37.4563,
      longitude: 126.7052,
      locality: '인천광역시 남동구',
      city: '인천광역시',
      district: '남동구',
    ),
    LocationPoint(
      latitude: 35.1601,
      longitude: 126.8514,
      locality: '광주광역시 서구',
      city: '광주광역시',
      district: '서구',
    ),
    LocationPoint(
      latitude: 36.3504,
      longitude: 127.3845,
      locality: '대전광역시 서구',
      city: '대전광역시',
      district: '서구',
    ),
    LocationPoint(
      latitude: 35.5384,
      longitude: 129.3114,
      locality: '울산광역시 남구',
      city: '울산광역시',
      district: '남구',
    ),
    LocationPoint(
      latitude: 33.4996,
      longitude: 126.5312,
      locality: '제주특별자치도 제주시',
      city: '제주특별자치도',
      district: '제주시',
    ),
    LocationPoint(
      latitude: 33.2530,
      longitude: 126.5600,
      locality: '제주특별자치도 서귀포시',
      city: '제주특별자치도',
      district: '서귀포시',
    ),
    // 강원/충청/전라/경상 주요 도시
    LocationPoint(
      latitude: 37.8813,
      longitude: 127.7300,
      locality: '강원특별자치도 춘천시',
      city: '강원특별자치도',
      district: '춘천시',
    ),
    LocationPoint(
      latitude: 37.7518,
      longitude: 128.8761,
      locality: '강원특별자치도 강릉시',
      city: '강원특별자치도',
      district: '강릉시',
    ),
    LocationPoint(
      latitude: 36.4801,
      longitude: 127.2892,
      locality: '세종특별자치시',
      city: '세종특별자치시',
      district: '세종시',
    ),
    LocationPoint(
      latitude: 36.6357,
      longitude: 127.4897,
      locality: '충청북도 청주시 상당구',
      city: '충청북도 청주시',
      district: '상당구',
    ),
    LocationPoint(
      latitude: 36.3505,
      longitude: 126.5860,
      locality: '충청남도 보령시',
      city: '충청남도',
      district: '보령시',
    ),
    LocationPoint(
      latitude: 35.1460,
      longitude: 126.9910,
      locality: '전라북도 전주시 완산구',
      city: '전라북도 전주시',
      district: '완산구',
    ),
    LocationPoint(
      latitude: 34.7604,
      longitude: 127.6622,
      locality: '전라남도 여수시',
      city: '전라남도',
      district: '여수시',
    ),
    LocationPoint(
      latitude: 35.8038,
      longitude: 128.7415,
      locality: '경상북도 경산시',
      city: '경상북도',
      district: '경산시',
    ),
    LocationPoint(
      latitude: 35.2372,
      longitude: 128.6927,
      locality: '경상남도 창원시 의창구',
      city: '경상남도 창원시',
      district: '의창구',
    ),
    LocationPoint(
      latitude: 35.1629,
      longitude: 128.9787,
      locality: '경상남도 김해시',
      city: '경상남도',
      district: '김해시',
    ),
  ];
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

final preferencesStorageProvider = FutureProvider<PreferencesStorage>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return PreferencesStorage(prefs);
});

final userPreferencesControllerProvider = AutoDisposeAsyncNotifierProvider<
    UserPreferencesController,
    UserPreferences>(
  UserPreferencesController.new,
);

final locationPointProvider = FutureProvider<LocationPoint>((ref) async {
  final service = ref.watch(locationServiceProvider);
  return service.resolveCurrentLocation();
});

final locationOptionsProvider = FutureProvider<List<LocationPoint>>((ref) async {
  final current = await ref.watch(locationPointProvider.future);
  final presets = ref.watch(presetLocationsProvider);

  final seen = <String>{};
  final options = <LocationPoint>[];

  void add(LocationPoint location) {
    final key = [
      location.latitude.toStringAsFixed(2),
      location.longitude.toStringAsFixed(2),
      location.city,
      location.district,
      location.locality,
    ].join('_');
    if (seen.add(key)) {
      options.add(location);
    }
  }

  add(current);
  for (final preset in presets) {
    add(preset);
  }

  return options;
});

class UserPreferencesController
    extends AutoDisposeAsyncNotifier<UserPreferences> {
  @override
  Future<UserPreferences> build() async {
    final storage = await ref.watch(preferencesStorageProvider.future);
    return storage.readPreferences();
  }

  Future<void> updatePreferences(UserPreferences preferences) async {
    state = AsyncData(preferences);
    final storage = await ref.watch(preferencesStorageProvider.future);
    await storage.writePreferences(preferences);
  }

  Future<void> updateGender(GenderPreference gender) async {
    final current = await future;
    await updatePreferences(current.copyWith(gender: gender));
  }

  Future<void> updateSensitivity(TemperatureSensitivity sensitivity) async {
    final current = await future;
    await updatePreferences(current.copyWith(sensitivity: sensitivity));
  }
}
