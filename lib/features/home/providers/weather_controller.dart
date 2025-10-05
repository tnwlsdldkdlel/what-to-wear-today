import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/advice/clothing_advisor.dart';
import '../../../core/models/user_preferences.dart';
import '../../../core/models/weather_models.dart';
import '../../../core/providers/app_providers.dart';

final weatherControllerProvider = AutoDisposeAsyncNotifierProvider<
    WeatherController,
    WeatherUiState>(
  WeatherController.new,
);

class WeatherUiState {
  WeatherUiState({
    required this.bundle,
    required this.advice,
    required this.location,
    required this.preferences,
  });

  final WeatherBundle bundle;
  final ClothingAdvice advice;
  final LocationPoint location;
  final UserPreferences preferences;
}

class WeatherController extends AutoDisposeAsyncNotifier<WeatherUiState> {
  LocationPoint? _overrideLocation;

  @override
  Future<WeatherUiState> build() async {
    final override = _overrideLocation;
    final LocationPoint location = override ??
        await ref.watch(locationPointProvider.future);
    final preferences = await ref.watch(userPreferencesControllerProvider.future);
    return _load(location: location, preferences: preferences);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final override = _overrideLocation;
      final LocationPoint location = override ??
          await ref.read(locationPointProvider.future);
      final preferences = await ref.read(userPreferencesControllerProvider.future);
      return _load(location: location, preferences: preferences);
    });
  }

  Future<void> setLocation(LocationPoint location) async {
    _overrideLocation = location;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final preferences = await ref.read(userPreferencesControllerProvider.future);
      return _load(location: location, preferences: preferences);
    });
  }

  Future<WeatherUiState> _load({
    required LocationPoint location,
    required UserPreferences preferences,
  }) async {
    final repository = ref.watch(weatherRepositoryProvider);
    final advisor = ref.watch(clothingAdvisorProvider);

    final bundle = await repository.fetchForLocation(location);
    final advice = advisor.buildAdvice(
      weather: bundle.current,
      preferences: preferences,
    );

    return WeatherUiState(
      bundle: bundle,
      advice: advice,
      location: location,
      preferences: preferences,
    );
  }
}
