import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_preferences.dart';

class PreferencesStorage {
  PreferencesStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _genderKey = 'user_gender';
  static const _sensitivityKey = 'user_sensitivity';

  Future<UserPreferences> readPreferences() async {
    final genderIndex = _prefs.getInt(_genderKey);
    final sensitivityIndex = _prefs.getInt(_sensitivityKey);

    return UserPreferences(
      gender: genderIndex != null &&
              genderIndex >= 0 &&
              genderIndex < GenderPreference.values.length
          ? GenderPreference.values[genderIndex]
          : GenderPreference.unspecified,
      sensitivity: sensitivityIndex != null &&
              sensitivityIndex >= 0 &&
              sensitivityIndex < TemperatureSensitivity.values.length
          ? TemperatureSensitivity.values[sensitivityIndex]
          : TemperatureSensitivity.neutral,
    );
  }

  Future<void> writePreferences(UserPreferences preferences) async {
    await Future.wait<void>([
      _prefs.setInt(_genderKey, preferences.gender.index),
      _prefs.setInt(_sensitivityKey, preferences.sensitivity.index),
    ]);
  }
}
