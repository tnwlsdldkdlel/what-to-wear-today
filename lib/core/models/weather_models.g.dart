// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeatherSnapshotImpl _$$WeatherSnapshotImplFromJson(
  Map<String, dynamic> json,
) => _$WeatherSnapshotImpl(
  timestamp: DateTime.parse(json['timestamp'] as String),
  temperatureC: (json['temperatureC'] as num).toDouble(),
  feelsLikeC: (json['feelsLikeC'] as num).toDouble(),
  conditionCode: json['conditionCode'] as String,
  conditionDescription: json['conditionDescription'] as String,
  precipitationChance: (json['precipitationChance'] as num).toDouble(),
  windSpeedKph: (json['windSpeedKph'] as num).toDouble(),
  humidityPercent: (json['humidityPercent'] as num).toDouble(),
);

Map<String, dynamic> _$$WeatherSnapshotImplToJson(
  _$WeatherSnapshotImpl instance,
) => <String, dynamic>{
  'timestamp': instance.timestamp.toIso8601String(),
  'temperatureC': instance.temperatureC,
  'feelsLikeC': instance.feelsLikeC,
  'conditionCode': instance.conditionCode,
  'conditionDescription': instance.conditionDescription,
  'precipitationChance': instance.precipitationChance,
  'windSpeedKph': instance.windSpeedKph,
  'humidityPercent': instance.humidityPercent,
};

_$DailyForecastImpl _$$DailyForecastImplFromJson(Map<String, dynamic> json) =>
    _$DailyForecastImpl(
      date: DateTime.parse(json['date'] as String),
      minTempC: (json['minTempC'] as num).toDouble(),
      maxTempC: (json['maxTempC'] as num).toDouble(),
      conditionCode: json['conditionCode'] as String,
      conditionDescription: json['conditionDescription'] as String,
      clothingSummary: json['clothingSummary'] as String? ?? '',
    );

Map<String, dynamic> _$$DailyForecastImplToJson(_$DailyForecastImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'minTempC': instance.minTempC,
      'maxTempC': instance.maxTempC,
      'conditionCode': instance.conditionCode,
      'conditionDescription': instance.conditionDescription,
      'clothingSummary': instance.clothingSummary,
    };

_$WeatherBundleImpl _$$WeatherBundleImplFromJson(Map<String, dynamic> json) =>
    _$WeatherBundleImpl(
      locationName: json['locationName'] as String,
      current: WeatherSnapshot.fromJson(
        json['current'] as Map<String, dynamic>,
      ),
      hourly:
          (json['hourly'] as List<dynamic>?)
              ?.map((e) => WeatherSnapshot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WeatherSnapshot>[],
      daily:
          (json['daily'] as List<dynamic>?)
              ?.map((e) => DailyForecast.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <DailyForecast>[],
      timezone: json['timezone'] as String? ?? '',
    );

Map<String, dynamic> _$$WeatherBundleImplToJson(_$WeatherBundleImpl instance) =>
    <String, dynamic>{
      'locationName': instance.locationName,
      'current': instance.current,
      'hourly': instance.hourly,
      'daily': instance.daily,
      'timezone': instance.timezone,
    };

_$LocationPointImpl _$$LocationPointImplFromJson(Map<String, dynamic> json) =>
    _$LocationPointImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      locality: json['locality'] as String? ?? '',
      city: json['city'] as String? ?? '',
      district: json['district'] as String? ?? '',
    );

Map<String, dynamic> _$$LocationPointImplToJson(_$LocationPointImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'locality': instance.locality,
      'city': instance.city,
      'district': instance.district,
    };
