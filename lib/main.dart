import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/config/environment.dart';
import 'core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env', mergeWith: Platform.environment);
  } catch (_) {
    // ignore: avoid_print
    print('Warning: .env 파일을 불러오지 못했습니다. 환경 변수 또는 Secret Manager 설정을 확인하세요.');
  }

  final env = AppEnvironment();
  await Supabase.initialize(url: env.supabaseUrl, anonKey: env.supabaseAnonKey);

  // 알림 서비스 초기화
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(const OutfitApp());

  // 앱 시작 후 알림 메시지 자동 업데이트 (백그라운드에서 실행)
  WidgetsBinding.instance.addPostFrameCallback((_) {
    notificationService.updateNotificationMessageIfNeeded();
  });
}
