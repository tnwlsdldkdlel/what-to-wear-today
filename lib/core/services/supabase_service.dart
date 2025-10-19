import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/outfit_submission.dart';

class SupabaseService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<void> submitOutfit(OutfitSubmission submission) async {
    try {
      await _client.from('outfit_submissions').insert(submission.toJson());
    } on PostgrestException catch (error) {
      throw StateError('Failed to submit outfit: ${error.message}');
    }
  }

  /// 디바이스 토큰 저장/업데이트
  Future<void> saveDeviceToken({
    required String deviceId,
    required bool isEnabled,
    required int notificationHour,
    required int notificationMinute,
  }) async {
    try {
      final platform = Platform.isIOS ? 'iOS' : 'Android';

      await _client.from('device_tokens').upsert(
        {
          'device_id': deviceId,
          'is_enabled': isEnabled,
          'notification_hour': notificationHour,
          'notification_minute': notificationMinute,
          'platform': platform,
        },
        onConflict: 'device_id',
      );
    } on PostgrestException catch (error) {
      throw StateError('Failed to save device token: ${error.message}');
    }
  }

  /// 디바이스 토큰 불러오기
  Future<Map<String, dynamic>?> getDeviceToken(String deviceId) async {
    try {
      final response = await _client
          .from('device_tokens')
          .select()
          .eq('device_id', deviceId)
          .maybeSingle();

      return response;
    } on PostgrestException catch (error) {
      print('Failed to get device token: ${error.message}');
      return null;
    }
  }
}
