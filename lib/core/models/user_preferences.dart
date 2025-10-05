import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preferences.freezed.dart';
part 'user_preferences.g.dart';

enum GenderPreference {
  female,
  male,
  nonBinary,
  unspecified,
}

enum TemperatureSensitivity {
  runsCold,
  neutral,
  runsHot,
}

enum LayerLevel {
  lighter,
  regular,
  heavier,
}

@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default(GenderPreference.unspecified) GenderPreference gender,
    @Default(TemperatureSensitivity.neutral)
    TemperatureSensitivity sensitivity,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}
