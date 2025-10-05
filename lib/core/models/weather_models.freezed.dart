// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WeatherSnapshot _$WeatherSnapshotFromJson(Map<String, dynamic> json) {
  return _WeatherSnapshot.fromJson(json);
}

/// @nodoc
mixin _$WeatherSnapshot {
  DateTime get timestamp => throw _privateConstructorUsedError;
  double get temperatureC => throw _privateConstructorUsedError;
  double get feelsLikeC => throw _privateConstructorUsedError;
  String get conditionCode => throw _privateConstructorUsedError;
  String get conditionDescription => throw _privateConstructorUsedError;
  double get precipitationChance => throw _privateConstructorUsedError;
  double get windSpeedKph => throw _privateConstructorUsedError;
  double get humidityPercent => throw _privateConstructorUsedError;

  /// Serializes this WeatherSnapshot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeatherSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeatherSnapshotCopyWith<WeatherSnapshot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherSnapshotCopyWith<$Res> {
  factory $WeatherSnapshotCopyWith(
    WeatherSnapshot value,
    $Res Function(WeatherSnapshot) then,
  ) = _$WeatherSnapshotCopyWithImpl<$Res, WeatherSnapshot>;
  @useResult
  $Res call({
    DateTime timestamp,
    double temperatureC,
    double feelsLikeC,
    String conditionCode,
    String conditionDescription,
    double precipitationChance,
    double windSpeedKph,
    double humidityPercent,
  });
}

/// @nodoc
class _$WeatherSnapshotCopyWithImpl<$Res, $Val extends WeatherSnapshot>
    implements $WeatherSnapshotCopyWith<$Res> {
  _$WeatherSnapshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeatherSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? temperatureC = null,
    Object? feelsLikeC = null,
    Object? conditionCode = null,
    Object? conditionDescription = null,
    Object? precipitationChance = null,
    Object? windSpeedKph = null,
    Object? humidityPercent = null,
  }) {
    return _then(
      _value.copyWith(
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            temperatureC: null == temperatureC
                ? _value.temperatureC
                : temperatureC // ignore: cast_nullable_to_non_nullable
                      as double,
            feelsLikeC: null == feelsLikeC
                ? _value.feelsLikeC
                : feelsLikeC // ignore: cast_nullable_to_non_nullable
                      as double,
            conditionCode: null == conditionCode
                ? _value.conditionCode
                : conditionCode // ignore: cast_nullable_to_non_nullable
                      as String,
            conditionDescription: null == conditionDescription
                ? _value.conditionDescription
                : conditionDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            precipitationChance: null == precipitationChance
                ? _value.precipitationChance
                : precipitationChance // ignore: cast_nullable_to_non_nullable
                      as double,
            windSpeedKph: null == windSpeedKph
                ? _value.windSpeedKph
                : windSpeedKph // ignore: cast_nullable_to_non_nullable
                      as double,
            humidityPercent: null == humidityPercent
                ? _value.humidityPercent
                : humidityPercent // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeatherSnapshotImplCopyWith<$Res>
    implements $WeatherSnapshotCopyWith<$Res> {
  factory _$$WeatherSnapshotImplCopyWith(
    _$WeatherSnapshotImpl value,
    $Res Function(_$WeatherSnapshotImpl) then,
  ) = __$$WeatherSnapshotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime timestamp,
    double temperatureC,
    double feelsLikeC,
    String conditionCode,
    String conditionDescription,
    double precipitationChance,
    double windSpeedKph,
    double humidityPercent,
  });
}

/// @nodoc
class __$$WeatherSnapshotImplCopyWithImpl<$Res>
    extends _$WeatherSnapshotCopyWithImpl<$Res, _$WeatherSnapshotImpl>
    implements _$$WeatherSnapshotImplCopyWith<$Res> {
  __$$WeatherSnapshotImplCopyWithImpl(
    _$WeatherSnapshotImpl _value,
    $Res Function(_$WeatherSnapshotImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeatherSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? temperatureC = null,
    Object? feelsLikeC = null,
    Object? conditionCode = null,
    Object? conditionDescription = null,
    Object? precipitationChance = null,
    Object? windSpeedKph = null,
    Object? humidityPercent = null,
  }) {
    return _then(
      _$WeatherSnapshotImpl(
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        temperatureC: null == temperatureC
            ? _value.temperatureC
            : temperatureC // ignore: cast_nullable_to_non_nullable
                  as double,
        feelsLikeC: null == feelsLikeC
            ? _value.feelsLikeC
            : feelsLikeC // ignore: cast_nullable_to_non_nullable
                  as double,
        conditionCode: null == conditionCode
            ? _value.conditionCode
            : conditionCode // ignore: cast_nullable_to_non_nullable
                  as String,
        conditionDescription: null == conditionDescription
            ? _value.conditionDescription
            : conditionDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        precipitationChance: null == precipitationChance
            ? _value.precipitationChance
            : precipitationChance // ignore: cast_nullable_to_non_nullable
                  as double,
        windSpeedKph: null == windSpeedKph
            ? _value.windSpeedKph
            : windSpeedKph // ignore: cast_nullable_to_non_nullable
                  as double,
        humidityPercent: null == humidityPercent
            ? _value.humidityPercent
            : humidityPercent // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherSnapshotImpl implements _WeatherSnapshot {
  const _$WeatherSnapshotImpl({
    required this.timestamp,
    required this.temperatureC,
    required this.feelsLikeC,
    required this.conditionCode,
    required this.conditionDescription,
    required this.precipitationChance,
    required this.windSpeedKph,
    required this.humidityPercent,
  });

  factory _$WeatherSnapshotImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherSnapshotImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  final double temperatureC;
  @override
  final double feelsLikeC;
  @override
  final String conditionCode;
  @override
  final String conditionDescription;
  @override
  final double precipitationChance;
  @override
  final double windSpeedKph;
  @override
  final double humidityPercent;

  @override
  String toString() {
    return 'WeatherSnapshot(timestamp: $timestamp, temperatureC: $temperatureC, feelsLikeC: $feelsLikeC, conditionCode: $conditionCode, conditionDescription: $conditionDescription, precipitationChance: $precipitationChance, windSpeedKph: $windSpeedKph, humidityPercent: $humidityPercent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherSnapshotImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.temperatureC, temperatureC) ||
                other.temperatureC == temperatureC) &&
            (identical(other.feelsLikeC, feelsLikeC) ||
                other.feelsLikeC == feelsLikeC) &&
            (identical(other.conditionCode, conditionCode) ||
                other.conditionCode == conditionCode) &&
            (identical(other.conditionDescription, conditionDescription) ||
                other.conditionDescription == conditionDescription) &&
            (identical(other.precipitationChance, precipitationChance) ||
                other.precipitationChance == precipitationChance) &&
            (identical(other.windSpeedKph, windSpeedKph) ||
                other.windSpeedKph == windSpeedKph) &&
            (identical(other.humidityPercent, humidityPercent) ||
                other.humidityPercent == humidityPercent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    timestamp,
    temperatureC,
    feelsLikeC,
    conditionCode,
    conditionDescription,
    precipitationChance,
    windSpeedKph,
    humidityPercent,
  );

  /// Create a copy of WeatherSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherSnapshotImplCopyWith<_$WeatherSnapshotImpl> get copyWith =>
      __$$WeatherSnapshotImplCopyWithImpl<_$WeatherSnapshotImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherSnapshotImplToJson(this);
  }
}

abstract class _WeatherSnapshot implements WeatherSnapshot {
  const factory _WeatherSnapshot({
    required final DateTime timestamp,
    required final double temperatureC,
    required final double feelsLikeC,
    required final String conditionCode,
    required final String conditionDescription,
    required final double precipitationChance,
    required final double windSpeedKph,
    required final double humidityPercent,
  }) = _$WeatherSnapshotImpl;

  factory _WeatherSnapshot.fromJson(Map<String, dynamic> json) =
      _$WeatherSnapshotImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  double get temperatureC;
  @override
  double get feelsLikeC;
  @override
  String get conditionCode;
  @override
  String get conditionDescription;
  @override
  double get precipitationChance;
  @override
  double get windSpeedKph;
  @override
  double get humidityPercent;

  /// Create a copy of WeatherSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeatherSnapshotImplCopyWith<_$WeatherSnapshotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyForecast _$DailyForecastFromJson(Map<String, dynamic> json) {
  return _DailyForecast.fromJson(json);
}

/// @nodoc
mixin _$DailyForecast {
  DateTime get date => throw _privateConstructorUsedError;
  double get minTempC => throw _privateConstructorUsedError;
  double get maxTempC => throw _privateConstructorUsedError;
  String get conditionCode => throw _privateConstructorUsedError;
  String get conditionDescription => throw _privateConstructorUsedError;
  String get clothingSummary => throw _privateConstructorUsedError;

  /// Serializes this DailyForecast to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyForecast
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyForecastCopyWith<DailyForecast> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyForecastCopyWith<$Res> {
  factory $DailyForecastCopyWith(
    DailyForecast value,
    $Res Function(DailyForecast) then,
  ) = _$DailyForecastCopyWithImpl<$Res, DailyForecast>;
  @useResult
  $Res call({
    DateTime date,
    double minTempC,
    double maxTempC,
    String conditionCode,
    String conditionDescription,
    String clothingSummary,
  });
}

/// @nodoc
class _$DailyForecastCopyWithImpl<$Res, $Val extends DailyForecast>
    implements $DailyForecastCopyWith<$Res> {
  _$DailyForecastCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyForecast
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? minTempC = null,
    Object? maxTempC = null,
    Object? conditionCode = null,
    Object? conditionDescription = null,
    Object? clothingSummary = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            minTempC: null == minTempC
                ? _value.minTempC
                : minTempC // ignore: cast_nullable_to_non_nullable
                      as double,
            maxTempC: null == maxTempC
                ? _value.maxTempC
                : maxTempC // ignore: cast_nullable_to_non_nullable
                      as double,
            conditionCode: null == conditionCode
                ? _value.conditionCode
                : conditionCode // ignore: cast_nullable_to_non_nullable
                      as String,
            conditionDescription: null == conditionDescription
                ? _value.conditionDescription
                : conditionDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            clothingSummary: null == clothingSummary
                ? _value.clothingSummary
                : clothingSummary // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyForecastImplCopyWith<$Res>
    implements $DailyForecastCopyWith<$Res> {
  factory _$$DailyForecastImplCopyWith(
    _$DailyForecastImpl value,
    $Res Function(_$DailyForecastImpl) then,
  ) = __$$DailyForecastImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime date,
    double minTempC,
    double maxTempC,
    String conditionCode,
    String conditionDescription,
    String clothingSummary,
  });
}

/// @nodoc
class __$$DailyForecastImplCopyWithImpl<$Res>
    extends _$DailyForecastCopyWithImpl<$Res, _$DailyForecastImpl>
    implements _$$DailyForecastImplCopyWith<$Res> {
  __$$DailyForecastImplCopyWithImpl(
    _$DailyForecastImpl _value,
    $Res Function(_$DailyForecastImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyForecast
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? minTempC = null,
    Object? maxTempC = null,
    Object? conditionCode = null,
    Object? conditionDescription = null,
    Object? clothingSummary = null,
  }) {
    return _then(
      _$DailyForecastImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        minTempC: null == minTempC
            ? _value.minTempC
            : minTempC // ignore: cast_nullable_to_non_nullable
                  as double,
        maxTempC: null == maxTempC
            ? _value.maxTempC
            : maxTempC // ignore: cast_nullable_to_non_nullable
                  as double,
        conditionCode: null == conditionCode
            ? _value.conditionCode
            : conditionCode // ignore: cast_nullable_to_non_nullable
                  as String,
        conditionDescription: null == conditionDescription
            ? _value.conditionDescription
            : conditionDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        clothingSummary: null == clothingSummary
            ? _value.clothingSummary
            : clothingSummary // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyForecastImpl implements _DailyForecast {
  const _$DailyForecastImpl({
    required this.date,
    required this.minTempC,
    required this.maxTempC,
    required this.conditionCode,
    required this.conditionDescription,
    this.clothingSummary = '',
  });

  factory _$DailyForecastImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyForecastImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double minTempC;
  @override
  final double maxTempC;
  @override
  final String conditionCode;
  @override
  final String conditionDescription;
  @override
  @JsonKey()
  final String clothingSummary;

  @override
  String toString() {
    return 'DailyForecast(date: $date, minTempC: $minTempC, maxTempC: $maxTempC, conditionCode: $conditionCode, conditionDescription: $conditionDescription, clothingSummary: $clothingSummary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyForecastImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.minTempC, minTempC) ||
                other.minTempC == minTempC) &&
            (identical(other.maxTempC, maxTempC) ||
                other.maxTempC == maxTempC) &&
            (identical(other.conditionCode, conditionCode) ||
                other.conditionCode == conditionCode) &&
            (identical(other.conditionDescription, conditionDescription) ||
                other.conditionDescription == conditionDescription) &&
            (identical(other.clothingSummary, clothingSummary) ||
                other.clothingSummary == clothingSummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    minTempC,
    maxTempC,
    conditionCode,
    conditionDescription,
    clothingSummary,
  );

  /// Create a copy of DailyForecast
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyForecastImplCopyWith<_$DailyForecastImpl> get copyWith =>
      __$$DailyForecastImplCopyWithImpl<_$DailyForecastImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyForecastImplToJson(this);
  }
}

abstract class _DailyForecast implements DailyForecast {
  const factory _DailyForecast({
    required final DateTime date,
    required final double minTempC,
    required final double maxTempC,
    required final String conditionCode,
    required final String conditionDescription,
    final String clothingSummary,
  }) = _$DailyForecastImpl;

  factory _DailyForecast.fromJson(Map<String, dynamic> json) =
      _$DailyForecastImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get minTempC;
  @override
  double get maxTempC;
  @override
  String get conditionCode;
  @override
  String get conditionDescription;
  @override
  String get clothingSummary;

  /// Create a copy of DailyForecast
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyForecastImplCopyWith<_$DailyForecastImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeatherBundle _$WeatherBundleFromJson(Map<String, dynamic> json) {
  return _WeatherBundle.fromJson(json);
}

/// @nodoc
mixin _$WeatherBundle {
  String get locationName => throw _privateConstructorUsedError;
  WeatherSnapshot get current => throw _privateConstructorUsedError;
  List<WeatherSnapshot> get hourly => throw _privateConstructorUsedError;
  List<DailyForecast> get daily => throw _privateConstructorUsedError;
  String get timezone => throw _privateConstructorUsedError;

  /// Serializes this WeatherBundle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeatherBundle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeatherBundleCopyWith<WeatherBundle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherBundleCopyWith<$Res> {
  factory $WeatherBundleCopyWith(
    WeatherBundle value,
    $Res Function(WeatherBundle) then,
  ) = _$WeatherBundleCopyWithImpl<$Res, WeatherBundle>;
  @useResult
  $Res call({
    String locationName,
    WeatherSnapshot current,
    List<WeatherSnapshot> hourly,
    List<DailyForecast> daily,
    String timezone,
  });

  $WeatherSnapshotCopyWith<$Res> get current;
}

/// @nodoc
class _$WeatherBundleCopyWithImpl<$Res, $Val extends WeatherBundle>
    implements $WeatherBundleCopyWith<$Res> {
  _$WeatherBundleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeatherBundle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationName = null,
    Object? current = null,
    Object? hourly = null,
    Object? daily = null,
    Object? timezone = null,
  }) {
    return _then(
      _value.copyWith(
            locationName: null == locationName
                ? _value.locationName
                : locationName // ignore: cast_nullable_to_non_nullable
                      as String,
            current: null == current
                ? _value.current
                : current // ignore: cast_nullable_to_non_nullable
                      as WeatherSnapshot,
            hourly: null == hourly
                ? _value.hourly
                : hourly // ignore: cast_nullable_to_non_nullable
                      as List<WeatherSnapshot>,
            daily: null == daily
                ? _value.daily
                : daily // ignore: cast_nullable_to_non_nullable
                      as List<DailyForecast>,
            timezone: null == timezone
                ? _value.timezone
                : timezone // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of WeatherBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeatherSnapshotCopyWith<$Res> get current {
    return $WeatherSnapshotCopyWith<$Res>(_value.current, (value) {
      return _then(_value.copyWith(current: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WeatherBundleImplCopyWith<$Res>
    implements $WeatherBundleCopyWith<$Res> {
  factory _$$WeatherBundleImplCopyWith(
    _$WeatherBundleImpl value,
    $Res Function(_$WeatherBundleImpl) then,
  ) = __$$WeatherBundleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String locationName,
    WeatherSnapshot current,
    List<WeatherSnapshot> hourly,
    List<DailyForecast> daily,
    String timezone,
  });

  @override
  $WeatherSnapshotCopyWith<$Res> get current;
}

/// @nodoc
class __$$WeatherBundleImplCopyWithImpl<$Res>
    extends _$WeatherBundleCopyWithImpl<$Res, _$WeatherBundleImpl>
    implements _$$WeatherBundleImplCopyWith<$Res> {
  __$$WeatherBundleImplCopyWithImpl(
    _$WeatherBundleImpl _value,
    $Res Function(_$WeatherBundleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeatherBundle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationName = null,
    Object? current = null,
    Object? hourly = null,
    Object? daily = null,
    Object? timezone = null,
  }) {
    return _then(
      _$WeatherBundleImpl(
        locationName: null == locationName
            ? _value.locationName
            : locationName // ignore: cast_nullable_to_non_nullable
                  as String,
        current: null == current
            ? _value.current
            : current // ignore: cast_nullable_to_non_nullable
                  as WeatherSnapshot,
        hourly: null == hourly
            ? _value._hourly
            : hourly // ignore: cast_nullable_to_non_nullable
                  as List<WeatherSnapshot>,
        daily: null == daily
            ? _value._daily
            : daily // ignore: cast_nullable_to_non_nullable
                  as List<DailyForecast>,
        timezone: null == timezone
            ? _value.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherBundleImpl implements _WeatherBundle {
  const _$WeatherBundleImpl({
    required this.locationName,
    required this.current,
    final List<WeatherSnapshot> hourly = const <WeatherSnapshot>[],
    final List<DailyForecast> daily = const <DailyForecast>[],
    this.timezone = '',
  }) : _hourly = hourly,
       _daily = daily;

  factory _$WeatherBundleImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherBundleImplFromJson(json);

  @override
  final String locationName;
  @override
  final WeatherSnapshot current;
  final List<WeatherSnapshot> _hourly;
  @override
  @JsonKey()
  List<WeatherSnapshot> get hourly {
    if (_hourly is EqualUnmodifiableListView) return _hourly;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hourly);
  }

  final List<DailyForecast> _daily;
  @override
  @JsonKey()
  List<DailyForecast> get daily {
    if (_daily is EqualUnmodifiableListView) return _daily;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daily);
  }

  @override
  @JsonKey()
  final String timezone;

  @override
  String toString() {
    return 'WeatherBundle(locationName: $locationName, current: $current, hourly: $hourly, daily: $daily, timezone: $timezone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherBundleImpl &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.current, current) || other.current == current) &&
            const DeepCollectionEquality().equals(other._hourly, _hourly) &&
            const DeepCollectionEquality().equals(other._daily, _daily) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    locationName,
    current,
    const DeepCollectionEquality().hash(_hourly),
    const DeepCollectionEquality().hash(_daily),
    timezone,
  );

  /// Create a copy of WeatherBundle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherBundleImplCopyWith<_$WeatherBundleImpl> get copyWith =>
      __$$WeatherBundleImplCopyWithImpl<_$WeatherBundleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherBundleImplToJson(this);
  }
}

abstract class _WeatherBundle implements WeatherBundle {
  const factory _WeatherBundle({
    required final String locationName,
    required final WeatherSnapshot current,
    final List<WeatherSnapshot> hourly,
    final List<DailyForecast> daily,
    final String timezone,
  }) = _$WeatherBundleImpl;

  factory _WeatherBundle.fromJson(Map<String, dynamic> json) =
      _$WeatherBundleImpl.fromJson;

  @override
  String get locationName;
  @override
  WeatherSnapshot get current;
  @override
  List<WeatherSnapshot> get hourly;
  @override
  List<DailyForecast> get daily;
  @override
  String get timezone;

  /// Create a copy of WeatherBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeatherBundleImplCopyWith<_$WeatherBundleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocationPoint _$LocationPointFromJson(Map<String, dynamic> json) {
  return _LocationPoint.fromJson(json);
}

/// @nodoc
mixin _$LocationPoint {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get locality => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get district => throw _privateConstructorUsedError;

  /// Serializes this LocationPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationPointCopyWith<LocationPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationPointCopyWith<$Res> {
  factory $LocationPointCopyWith(
    LocationPoint value,
    $Res Function(LocationPoint) then,
  ) = _$LocationPointCopyWithImpl<$Res, LocationPoint>;
  @useResult
  $Res call({
    double latitude,
    double longitude,
    String locality,
    String city,
    String district,
  });
}

/// @nodoc
class _$LocationPointCopyWithImpl<$Res, $Val extends LocationPoint>
    implements $LocationPointCopyWith<$Res> {
  _$LocationPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? locality = null,
    Object? city = null,
    Object? district = null,
  }) {
    return _then(
      _value.copyWith(
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            locality: null == locality
                ? _value.locality
                : locality // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            district: null == district
                ? _value.district
                : district // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationPointImplCopyWith<$Res>
    implements $LocationPointCopyWith<$Res> {
  factory _$$LocationPointImplCopyWith(
    _$LocationPointImpl value,
    $Res Function(_$LocationPointImpl) then,
  ) = __$$LocationPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double latitude,
    double longitude,
    String locality,
    String city,
    String district,
  });
}

/// @nodoc
class __$$LocationPointImplCopyWithImpl<$Res>
    extends _$LocationPointCopyWithImpl<$Res, _$LocationPointImpl>
    implements _$$LocationPointImplCopyWith<$Res> {
  __$$LocationPointImplCopyWithImpl(
    _$LocationPointImpl _value,
    $Res Function(_$LocationPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? locality = null,
    Object? city = null,
    Object? district = null,
  }) {
    return _then(
      _$LocationPointImpl(
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        locality: null == locality
            ? _value.locality
            : locality // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        district: null == district
            ? _value.district
            : district // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationPointImpl implements _LocationPoint {
  const _$LocationPointImpl({
    required this.latitude,
    required this.longitude,
    this.locality = '',
    this.city = '',
    this.district = '',
  });

  factory _$LocationPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationPointImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  @JsonKey()
  final String locality;
  @override
  @JsonKey()
  final String city;
  @override
  @JsonKey()
  final String district;

  @override
  String toString() {
    return 'LocationPoint(latitude: $latitude, longitude: $longitude, locality: $locality, city: $city, district: $district)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationPointImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.locality, locality) ||
                other.locality == locality) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.district, district) ||
                other.district == district));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, latitude, longitude, locality, city, district);

  /// Create a copy of LocationPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationPointImplCopyWith<_$LocationPointImpl> get copyWith =>
      __$$LocationPointImplCopyWithImpl<_$LocationPointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationPointImplToJson(this);
  }
}

abstract class _LocationPoint implements LocationPoint {
  const factory _LocationPoint({
    required final double latitude,
    required final double longitude,
    final String locality,
    final String city,
    final String district,
  }) = _$LocationPointImpl;

  factory _LocationPoint.fromJson(Map<String, dynamic> json) =
      _$LocationPointImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get locality;
  @override
  String get city;
  @override
  String get district;

  /// Create a copy of LocationPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationPointImplCopyWith<_$LocationPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
