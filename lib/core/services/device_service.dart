import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceService {
  static const String _deviceIdKey = 'device_id';

  /// 디바이스 고유 ID를 가져옵니다.
  /// 저장된 ID가 없으면 새로 생성하여 저장합니다.
  Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();

    // 저장된 device_id가 있으면 반환
    final storedId = prefs.getString(_deviceIdKey);
    if (storedId != null && storedId.isNotEmpty) {
      return storedId;
    }

    // 없으면 새로 생성하여 저장
    const uuid = Uuid();
    final newId = uuid.v4();
    await prefs.setString(_deviceIdKey, newId);
    return newId;
  }

  /// 디바이스 ID를 초기화합니다 (테스트/디버깅용)
  Future<void> clearDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_deviceIdKey);
  }
}
