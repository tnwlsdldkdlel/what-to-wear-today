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

  /// 특정 지역과 온도 범위의 오늘 착장 데이터 조회
  ///
  /// [cityName]: 지역명 (예: '서울특별시', '부산광역시')
  /// [temperature]: 현재 온도
  /// [tempRange]: 온도 범위 (기본 ±5도)
  /// 오늘 제출된 해당 지역의 유사 온도대 착장 데이터를 반환
  Future<List<Map<String, dynamic>>> getOutfitsByTemperature({
    required String cityName,
    required double temperature,
    double tempRange = 5.0,
  }) async {
    try {
      // 최근 7일간의 데이터 조회 (오늘만 조회하면 데이터가 없을 수 있음)
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));

      print('Fetching outfits for city: $cityName');

      // city_name이 null이거나 빈 문자열이면 모든 데이터 조회
      var query = _client
          .from('outfit_submissions')
          .select('top, bottom, outerwear, shoes, accessories, city_name')
          .gte('reported_at', weekAgo.toIso8601String());

      // city_name이 있으면 필터 추가
      if (cityName.isNotEmpty) {
        query = query.eq('city_name', cityName);
      }

      final response = await query;
      final submissions = response as List<dynamic>;

      print('Found ${submissions.length} outfit submissions');
      if (submissions.isNotEmpty) {
        print('Sample submission: ${submissions.first}');
      }

      return submissions.map((e) => e as Map<String, dynamic>).toList();
    } on PostgrestException catch (error) {
      print('Failed to get outfits by temperature: ${error.message}');
      return [];
    } catch (error) {
      print('Unexpected error getting outfits: $error');
      return [];
    }
  }

  /// 특정 지역의 오늘 인기 착장 조회
  ///
  /// [cityName]: 지역명 (예: '서울특별시', '부산광역시')
  /// 최근 7일간 제출된 데이터 중 가장 많이 입은 전체 착장 조합을 반환
  Future<PopularOutfit?> getPopularOutfit(String cityName) async {
    try {
      // 최근 7일간의 데이터 조회
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));

      print('Fetching popular outfit for city: $cityName');

      // 해당 지역의 데이터 조회 (최신 데이터 우선을 위해 reported_at 포함)
      var query = _client
          .from('outfit_submissions')
          .select('top, bottom, outerwear, shoes, accessories, city_name, reported_at')
          .gte('reported_at', weekAgo.toIso8601String());

      // city_name이 있으면 필터 추가
      if (cityName.isNotEmpty) {
        query = query.eq('city_name', cityName);
      }

      final response = await query;

      final submissions = response as List<dynamic>;

      print('Found ${submissions.length} submissions for popular outfit');

      if (submissions.isEmpty) {
        print('No submissions found, returning null');
        return null;
      }

      // 각 카테고리별 아이템 빈도와 최신 타임스탬프 집계
      final topCounts = <String, ({int count, DateTime latestTime})>{};
      final bottomCounts = <String, ({int count, DateTime latestTime})>{};
      final outerwearCounts = <String, ({int count, DateTime latestTime})>{};
      final shoesCounts = <String, ({int count, DateTime latestTime})>{};
      final accessoriesCounts = <String, ({int count, DateTime latestTime})>{};

      for (final submission in submissions) {
        final top = submission['top'] as String;
        final bottom = submission['bottom'] as String;
        final outerwear = submission['outerwear'] as String?;
        final shoes = submission['shoes'] as String?;
        final accessories = submission['accessories'] as List<dynamic>?;
        final reportedAt = DateTime.parse(submission['reported_at'] as String);

        // Top 집계
        final currentTop = topCounts[top];
        topCounts[top] = currentTop == null
            ? (count: 1, latestTime: reportedAt)
            : (
                count: currentTop.count + 1,
                latestTime: reportedAt.isAfter(currentTop.latestTime)
                    ? reportedAt
                    : currentTop.latestTime,
              );

        // Bottom 집계
        final currentBottom = bottomCounts[bottom];
        bottomCounts[bottom] = currentBottom == null
            ? (count: 1, latestTime: reportedAt)
            : (
                count: currentBottom.count + 1,
                latestTime: reportedAt.isAfter(currentBottom.latestTime)
                    ? reportedAt
                    : currentBottom.latestTime,
              );

        // Outerwear 집계
        if (outerwear != null && outerwear.isNotEmpty) {
          final currentOuterwear = outerwearCounts[outerwear];
          outerwearCounts[outerwear] = currentOuterwear == null
              ? (count: 1, latestTime: reportedAt)
              : (
                  count: currentOuterwear.count + 1,
                  latestTime: reportedAt.isAfter(currentOuterwear.latestTime)
                      ? reportedAt
                      : currentOuterwear.latestTime,
                );
        }

        // Shoes 집계
        if (shoes != null && shoes.isNotEmpty) {
          final currentShoes = shoesCounts[shoes];
          shoesCounts[shoes] = currentShoes == null
              ? (count: 1, latestTime: reportedAt)
              : (
                  count: currentShoes.count + 1,
                  latestTime: reportedAt.isAfter(currentShoes.latestTime)
                      ? reportedAt
                      : currentShoes.latestTime,
                );
        }

        // Accessories 집계
        if (accessories != null) {
          for (final acc in accessories) {
            final accStr = acc as String;
            final currentAcc = accessoriesCounts[accStr];
            accessoriesCounts[accStr] = currentAcc == null
                ? (count: 1, latestTime: reportedAt)
                : (
                    count: currentAcc.count + 1,
                    latestTime: reportedAt.isAfter(currentAcc.latestTime)
                        ? reportedAt
                        : currentAcc.latestTime,
                  );
          }
        }
      }

      // 각 카테고리에서 가장 많이 입은 아이템 찾기 (동점 시 최신 데이터 우선)
      String? mostPopularTop;
      String? mostPopularBottom;
      String? mostPopularOuterwear;
      String? mostPopularShoes;
      List<String>? mostPopularAccessories;

      if (topCounts.isNotEmpty) {
        mostPopularTop = topCounts.entries.reduce((a, b) {
          if (a.value.count != b.value.count) {
            return a.value.count > b.value.count ? a : b;
          }
          return a.value.latestTime.isAfter(b.value.latestTime) ? a : b;
        }).key;
      }
      if (bottomCounts.isNotEmpty) {
        mostPopularBottom = bottomCounts.entries.reduce((a, b) {
          if (a.value.count != b.value.count) {
            return a.value.count > b.value.count ? a : b;
          }
          return a.value.latestTime.isAfter(b.value.latestTime) ? a : b;
        }).key;
      }
      if (outerwearCounts.isNotEmpty) {
        mostPopularOuterwear = outerwearCounts.entries.reduce((a, b) {
          if (a.value.count != b.value.count) {
            return a.value.count > b.value.count ? a : b;
          }
          return a.value.latestTime.isAfter(b.value.latestTime) ? a : b;
        }).key;
      }
      if (shoesCounts.isNotEmpty) {
        mostPopularShoes = shoesCounts.entries.reduce((a, b) {
          if (a.value.count != b.value.count) {
            return a.value.count > b.value.count ? a : b;
          }
          return a.value.latestTime.isAfter(b.value.latestTime) ? a : b;
        }).key;
      }
      // 악세서리는 상위 3개까지 (동점 시 최신 데이터 우선)
      if (accessoriesCounts.isNotEmpty) {
        final sortedAccessories = accessoriesCounts.entries.toList()
          ..sort((a, b) {
            if (a.value.count != b.value.count) {
              return b.value.count.compareTo(a.value.count);
            }
            return b.value.latestTime.compareTo(a.value.latestTime);
          });
        mostPopularAccessories =
            sortedAccessories.take(3).map((e) => e.key).toList();
      }

      if (mostPopularTop == null || mostPopularBottom == null) {
        return null;
      }

      print(
          'Most popular outfit: $mostPopularTop, $mostPopularBottom (from ${submissions.length} submissions)');

      return PopularOutfit(
        top: mostPopularTop,
        bottom: mostPopularBottom,
        outerwear: mostPopularOuterwear,
        shoes: mostPopularShoes,
        accessories: mostPopularAccessories,
        count: submissions.length,
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
