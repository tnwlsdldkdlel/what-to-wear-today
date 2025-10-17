import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_settings.dart';

/// 알림 설정 관리 서비스
class NotificationService {
  static const String _settingsKey = 'notification_settings';

  /// 알림 설정 저장
  Future<void> saveSettings(NotificationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(settings.toJson());
    await prefs.setString(_settingsKey, jsonString);

    // 알림이 활성화되어 있으면 스케줄링
    if (settings.isEnabled) {
      await _scheduleNotification(settings);
    } else {
      await _cancelNotification();
    }
  }

  /// 알림 설정 불러오기
  Future<NotificationSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_settingsKey);

    if (jsonString == null) {
      return NotificationSettings.defaultSettings();
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return NotificationSettings.fromJson(json);
    } catch (e) {
      // JSON 파싱 실패 시 기본값 반환
      return NotificationSettings.defaultSettings();
    }
  }

  /// 알림 스케줄링 (TODO: flutter_local_notifications 구현 필요)
  Future<void> _scheduleNotification(NotificationSettings settings) async {
    // TODO: flutter_local_notifications를 사용한 매일 반복 알림 설정
    // 1. 알림 초기화
    // 2. 매일 지정된 시간(settings.notificationTime)에 알림 표시
    // 3. 알림 내용: "오늘의 날씨와 추천 착장을 확인해보세요!"
    print('알림 스케줄 설정: ${settings.notificationTime.hour}:${settings.notificationTime.minute}');
  }

  /// 알림 취소 (TODO: flutter_local_notifications 구현 필요)
  Future<void> _cancelNotification() async {
    // TODO: 예약된 알림 취소
    print('알림 스케줄 취소');
  }

  /// 알림 권한 요청 (TODO: flutter_local_notifications 구현 필요)
  Future<bool> requestPermission() async {
    // TODO: iOS/Android 알림 권한 요청
    // iOS: UNUserNotificationCenter
    // Android: AndroidNotificationChannel
    return true; // 임시로 true 반환
  }

  /// 알림 초기화 (앱 시작 시 호출)
  Future<void> initialize() async {
    // TODO: flutter_local_notifications 초기화
    // 1. 알림 채널 설정 (Android)
    // 2. 알림 권한 확인
    // 3. 저장된 설정에 따라 알림 스케줄링
    final settings = await loadSettings();
    if (settings.isEnabled) {
      await _scheduleNotification(settings);
    }
  }
}
