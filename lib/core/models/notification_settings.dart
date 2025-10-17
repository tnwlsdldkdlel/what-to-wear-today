import 'package:flutter/material.dart';

/// 알림 설정 모델
class NotificationSettings {
  final bool isEnabled;
  final TimeOfDay notificationTime;

  const NotificationSettings({
    required this.isEnabled,
    required this.notificationTime,
  });

  /// 기본 설정값 (알림 비활성화, 오전 8시)
  factory NotificationSettings.defaultSettings() {
    return const NotificationSettings(
      isEnabled: false,
      notificationTime: TimeOfDay(hour: 8, minute: 0),
    );
  }

  /// JSON에서 객체 생성
  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      isEnabled: json['isEnabled'] as bool,
      notificationTime: TimeOfDay(
        hour: json['hour'] as int,
        minute: json['minute'] as int,
      ),
    );
  }

  /// 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'isEnabled': isEnabled,
      'hour': notificationTime.hour,
      'minute': notificationTime.minute,
    };
  }

  /// 설정 복사 (불변 객체 업데이트용)
  NotificationSettings copyWith({
    bool? isEnabled,
    TimeOfDay? notificationTime,
  }) {
    return NotificationSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      notificationTime: notificationTime ?? this.notificationTime,
    );
  }
}
