import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/outfit_submission.dart';
import '../models/popular_outfit.dart';

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

  /// 특정 지역의 오늘 인기 착장 조회
  ///
  /// [cityName]: 지역명 (예: '서울특별시', '부산광역시')
  /// 오늘 새벽 0시 이후 제출된 데이터 중 가장 많이 입은 상의+하의 조합을 반환
  Future<PopularOutfit?> getPopularOutfit(String cityName) async {
    try {
      // 오늘 새벽 0시 계산
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);

      // 오늘 제출된 해당 지역의 데이터 조회
      final response = await _client
          .from('outfit_submissions')
          .select('top, bottom, city_name')
          .eq('city_name', cityName)
          .gte('reported_at', todayStart.toIso8601String());

      final submissions = response as List<dynamic>;

      if (submissions.isEmpty) {
        return null;
      }

      // 클라이언트 측에서 상의+하의 조합별로 집계
      final Map<String, int> combinationCounts = {};

      for (final submission in submissions) {
        final top = submission['top'] as String;
        final bottom = submission['bottom'] as String;
        final key = '$top|$bottom';
        combinationCounts[key] = (combinationCounts[key] ?? 0) + 1;
      }

      if (combinationCounts.isEmpty) {
        return null;
      }

      // 가장 많이 입은 조합 찾기
      final mostPopular = combinationCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b);

      final parts = mostPopular.key.split('|');
      return PopularOutfit(
        top: parts[0],
        bottom: parts[1],
        count: mostPopular.value,
        cityName: cityName,
      );
    } on PostgrestException catch (error) {
      print('Failed to get popular outfit: ${error.message}');
      return null;
    } catch (error) {
      print('Unexpected error getting popular outfit: $error');
      return null;
    }
  }
}
