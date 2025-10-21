import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../app/routes/app_routes.dart';
import '../models/notification_settings.dart';
import 'device_service.dart';
import 'location_service.dart';
import 'supabase_service.dart';

/// 알림 설정 관리 서비스
class NotificationService {
  NotificationService({
    DeviceService? deviceService,
    SupabaseService? supabaseService,
    LocationService? locationService,
  })  : _deviceService = deviceService ?? DeviceService(),
        _supabaseService = supabaseService ?? SupabaseService(),
        _locationService = locationService ?? LocationService();

  static const String _settingsKey = 'notification_settings';
  static const int _notificationId = 0;

  final DeviceService _deviceService;
  final SupabaseService _supabaseService;
  final LocationService _locationService;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// 알림 설정 저장
  Future<void> saveSettings(NotificationSettings settings) async {
    // SharedPreferences에 저장
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(settings.toJson());
    await prefs.setString(_settingsKey, jsonString);

    print('🔔 saveSettings - Saved: isEnabled=${settings.isEnabled}, time=${settings.notificationTime.hour}:${settings.notificationTime.minute}');

    // Supabase device_tokens 테이블에 저장
    try {
      final deviceId = await _deviceService.getDeviceId();

      await _supabaseService.saveDeviceToken(
        deviceId: deviceId,
        isEnabled: settings.isEnabled,
        notificationHour: settings.notificationTime.hour,
        notificationMinute: settings.notificationTime.minute,
      );

      print('🔔 saveSettings - Saved to Supabase: deviceId=$deviceId');
    } catch (e) {
      print('🔔 saveSettings - Failed to save to Supabase: $e');
      // Supabase 저장 실패해도 로컬 설정은 유지
    }

    // 알림이 활성화되어 있으면 스케줄링
    if (settings.isEnabled) {
      await _scheduleNotification(settings);
    } else {
      await _cancelNotification();
    }
  }

  /// 알림 설정 초기화 (디버깅용)
  Future<void> clearSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_settingsKey);
    print('🔔 clearSettings - Cleared all notification settings');
  }

  /// 알림 설정 불러오기
  Future<NotificationSettings> loadSettings() async {
    // Supabase에서 먼저 조회 (single source of truth)
    try {
      final deviceId = await _deviceService.getDeviceId();
      final supabaseData = await _supabaseService.getDeviceToken(deviceId);

      if (supabaseData != null) {
        final settings = NotificationSettings(
          isEnabled: supabaseData['is_enabled'] as bool? ?? false,
          notificationTime: TimeOfDay(
            hour: supabaseData['notification_hour'] as int? ?? 8,
            minute: supabaseData['notification_minute'] as int? ?? 0,
          ),
        );

        print('🔔 loadSettings - Loaded from Supabase: isEnabled=${settings.isEnabled}');

        // SharedPreferences도 동기화
        final prefs = await SharedPreferences.getInstance();
        final jsonString = jsonEncode(settings.toJson());
        await prefs.setString(_settingsKey, jsonString);

        return settings;
      }
    } catch (e) {
      print('🔔 loadSettings - Failed to load from Supabase: $e');
    }

    // Supabase에 데이터가 없으면 기본값 반환
    print('🔔 loadSettings - No data in Supabase, returning default (isEnabled: false)');

    // SharedPreferences도 초기화
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_settingsKey);

    return NotificationSettings.defaultSettings();
  }

  /// 알림 스케줄링
  Future<void> _scheduleNotification(NotificationSettings settings) async {
    // 기존 알림 취소
    await _cancelNotification();

    // 인기 착장 메시지 가져오기
    String notificationBody = '오늘의 날씨와 추천 착장을 확인하세요!';
    try {
      final position = await _locationService.getCurrentPosition();
      final cityName = await _locationService.getCityName(position);
      final popularOutfit = await _supabaseService.getPopularOutfit(cityName);

      if (popularOutfit != null) {
        notificationBody = popularOutfit.buildRecommendationMessage();
      }
    } catch (e) {
      print('🔔 _scheduleNotification - Failed to get popular outfit: $e');
      // 실패 시 기본 메시지 사용
    }

    // 알림 상세 설정
    const androidDetails = AndroidNotificationDetails(
      'daily_notification',
      '날씨 알림',
      channelDescription: '매일 설정한 시간에 날씨와 추천 착장을 알려드립니다',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 알림 시간 설정
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      settings.notificationTime.hour,
      settings.notificationTime.minute,
    );

    // 이미 지난 시간이면 다음 날로 설정
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // 매일 반복 알림 스케줄링
    await _notificationsPlugin.zonedSchedule(
      _notificationId,
      '오늘 뭐 입음?',
      notificationBody,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// 알림 취소
  Future<void> _cancelNotification() async {
    await _notificationsPlugin.cancel(_notificationId);
  }

  /// 알림 권한 요청
  Future<bool> requestPermission() async {
    // Android 13+ 알림 권한 요청
    final androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final granted = await androidImplementation.requestNotificationsPermission();
      return granted ?? false;
    }

    // iOS 알림 권한 요청
    final iosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  /// 알림 클릭 시 처리
  void _onNotificationTapped(NotificationResponse response) {
    // 홈 화면으로 이동
    Get.offAllNamed(AppRoutes.home);
  }

  /// 알림 초기화 (앱 시작 시 호출)
  Future<void> initialize() async {
    // Timezone 초기화
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    // Android 설정
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 설정
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 알림 플러그인 초기화
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // 저장된 설정에 따라 알림 스케줄링
    final settings = await loadSettings();
    if (settings.isEnabled) {
      await _scheduleNotification(settings);
    }
  }

  /// 알림 메시지 업데이트 (앱 실행 시 자동 호출)
  ///
  /// 알림이 활성화되어 있으면 최신 인기 착장 데이터로 알림 메시지를 조용히 업데이트합니다.
  /// 사용자에게 보이는 UI 변경 없이 백그라운드에서 실행됩니다.
  Future<void> updateNotificationMessageIfNeeded() async {
    try {
      final settings = await loadSettings();
      if (settings.isEnabled) {
        print('🔔 updateNotificationMessageIfNeeded - Updating notification message...');
        // 조용히 알림 메시지 재설정 (최신 인기 착장 반영)
        await _scheduleNotification(settings);
        print('🔔 updateNotificationMessageIfNeeded - Notification message updated successfully');
      } else {
        print('🔔 updateNotificationMessageIfNeeded - Notification is disabled, skipping update');
      }
    } catch (e) {
      print('🔔 updateNotificationMessageIfNeeded - Failed to update: $e');
      // 실패해도 앱 실행에는 영향 없음
    }
  }
}
