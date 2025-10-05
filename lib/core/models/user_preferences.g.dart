// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPreferencesImpl _$$UserPreferencesImplFromJson(
  Map<String, dynamic> json,
) => _$UserPreferencesImpl(
  gender:
      $enumDecodeNullable(_$GenderPreferenceEnumMap, json['gender']) ??
      GenderPreference.unspecified,
  sensitivity:
      $enumDecodeNullable(
        _$TemperatureSensitivityEnumMap,
        json['sensitivity'],
      ) ??
      TemperatureSensitivity.neutral,
);

Map<String, dynamic> _$$UserPreferencesImplToJson(
  _$UserPreferencesImpl instance,
) => <String, dynamic>{
  'gender': _$GenderPreferenceEnumMap[instance.gender]!,
  'sensitivity': _$TemperatureSensitivityEnumMap[instance.sensitivity]!,
};

const _$GenderPreferenceEnumMap = {
  GenderPreference.female: 'female',
  GenderPreference.male: 'male',
  GenderPreference.nonBinary: 'nonBinary',
  GenderPreference.unspecified: 'unspecified',
};

const _$TemperatureSensitivityEnumMap = {
  TemperatureSensitivity.runsCold: 'runsCold',
  TemperatureSensitivity.neutral: 'neutral',
  TemperatureSensitivity.runsHot: 'runsHot',
};
