import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_models.freezed.dart';
part 'weather_models.g.dart';

/// Lightweight snapshot representing the weather at a point in time.
@freezed
class WeatherSnapshot with _$WeatherSnapshot {
  const factory WeatherSnapshot({
    required DateTime timestamp,
    required double temperatureC,
    required double feelsLikeC,
    required String conditionCode,
    required String conditionDescription,
    required double precipitationChance,
    required double windSpeedKph,
    required double humidityPercent,
  }) = _WeatherSnapshot;

  factory WeatherSnapshot.fromJson(Map<String, dynamic> json) =>
      _$WeatherSnapshotFromJson(json);
}

/// Daily level forecast used in the weekly overview.
@freezed
class DailyForecast with _$DailyForecast {
  const factory DailyForecast({
    required DateTime date,
    required double minTempC,
    required double maxTempC,
    required String conditionCode,
    required String conditionDescription,
    @Default('') String clothingSummary,
  }) = _DailyForecast;

  factory DailyForecast.fromJson(Map<String, dynamic> json) =>
      _$DailyForecastFromJson(json);
}

/// Aggregate of current, hourly and daily forecasts for a location.
@freezed
class WeatherBundle with _$WeatherBundle {
  const factory WeatherBundle({
    required String locationName,
    required WeatherSnapshot current,
    @Default(<WeatherSnapshot>[]) List<WeatherSnapshot> hourly,
    @Default(<DailyForecast>[]) List<DailyForecast> daily,
    @Default('') String timezone,
  }) = _WeatherBundle;

  factory WeatherBundle.fromJson(Map<String, dynamic> json) =>
      _$WeatherBundleFromJson(json);
}

/// Simple container for geographic coordinates used when requesting weather.
@freezed
class LocationPoint with _$LocationPoint {
  const factory LocationPoint({
    required double latitude,
    required double longitude,
    @Default('') String locality,
    @Default('') String city,
    @Default('') String district,
  }) = _LocationPoint;

  factory LocationPoint.fromJson(Map<String, dynamic> json) =>
      _$LocationPointFromJson(json);
}
