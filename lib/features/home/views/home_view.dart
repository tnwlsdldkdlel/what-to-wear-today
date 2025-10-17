import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/themes/app_theme.dart';
import '../../../core/models/notification_settings.dart';
import '../../../core/models/recommendation.dart';
import '../../../core/services/notification_service.dart';
import '../../shared/widgets/async_value_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const NotificationSettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘 뭐 입음?'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () => _showNotificationSettings(context),
              icon: const Icon(Icons.notifications_outlined),
              tooltip: '알림 설정',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.errorMessage.value.isNotEmpty) {
              return AsyncErrorView(
                message: controller.errorMessage.value,
                onRetry: controller.fetchRecommendation,
              );
            }
            final data = controller.recommendation.value;
            if (data == null) {
              return const AsyncEmptyView(message: '추천 데이터를 불러오지 못했습니다.');
            }
            return HomeContent(
                recommendation: data, area: controller.areaLabel.value);
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.submissionTop),
        label: const Text('내 착장 공유하기'),
        icon: const Icon(Icons.checkroom_outlined),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.recommendation,
    required this.area,
  });

  final Recommendation recommendation;
  final String area;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeroWeatherCard(recommendation: recommendation, area: area),
        const SizedBox(height: 24),
        Text(
          recommendation.buildSummarySentence(),
          style:
              theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '근처 이용자 착장 데이터를 기반으로 추천합니다.',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              final tiles = [
                _RecommendationTile(
                  title: 'TOP',
                  items: recommendation.tops,
                  chipColor: AppColors.primary,
                ),
                _RecommendationTile(
                  title: 'BOTTOM',
                  items: recommendation.bottoms,
                  chipColor: AppColors.accent,
                ),
                _RecommendationTile(
                  title: 'OUTER',
                  items: recommendation.outerwear,
                  chipColor: AppColors.cold,
                ),
                _RecommendationTile(
                  title: 'SHOES',
                  items: recommendation.shoes,
                  chipColor: AppColors.justRight,
                ),
                _RecommendationTile(
                  title: 'ACC',
                  items: recommendation.accessories,
                  chipColor: AppColors.hot,
                ),
              ];
              return tiles[index];
            },
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: 5,
          ),
        ),
      ],
    );
  }
}

class _HeroWeatherCard extends StatelessWidget {
  const _HeroWeatherCard({
    required this.recommendation,
    required this.area,
  });

  final Recommendation recommendation;
  final String area;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _WeatherIcon(code: recommendation.weatherIcon),
                const SizedBox(width: 12),
                Text(
                  '${recommendation.temperature.toStringAsFixed(1)}°',
                  style: theme.textTheme.headlineSmall?.copyWith(fontSize: 40),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              area,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final icon = _mapToIcon(code);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primary, size: 32),
    );
  }

  IconData _mapToIcon(String code) {
    switch (code) {
      case 'sunny':
        return Icons.wb_sunny_rounded;
      case 'partly_cloudy':
        return Icons.cloud_queue_rounded;
      case 'rain':
      case 'heavy_rain':
        return Icons.grain_rounded;
      case 'fog':
        return Icons.blur_on_rounded;
      case 'snow':
      case 'heavy_snow':
        return Icons.ac_unit_rounded;
      case 'storm':
        return Icons.flash_on_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({
    required this.title,
    required this.items,
    required this.chipColor,
  });

  final String title;
  final List<RecommendationItem> items;
  final Color chipColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: items
                  .map(
                    (item) => Chip(
                      label: Text(
                          '${item.label} ${(item.probability * 100).toStringAsFixed(0)}%'),
                      backgroundColor: chipColor.withOpacity(0.15),
                      side: BorderSide(color: chipColor.withOpacity(0.35)),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSettingsSheet extends StatefulWidget {
  const NotificationSettingsSheet({super.key});

  @override
  State<NotificationSettingsSheet> createState() =>
      _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState extends State<NotificationSettingsSheet> {
  final _notificationService = NotificationService();
  bool _isEnabled = false;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _notificationService.loadSettings();
    setState(() {
      _isEnabled = settings.isEnabled;
      _selectedTime = settings.notificationTime;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final settings = NotificationSettings(
      isEnabled: _isEnabled,
      notificationTime: _selectedTime,
    );
    await _notificationService.saveSettings(settings);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _selectTime() {
    BottomPicker.time(
      pickerTitle: Text(
        '알림 시간 선택',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      initialTime: Time(
        hours: _selectedTime.hour,
        minutes: _selectedTime.minute,
      ),
      use24hFormat: true,
      onSubmit: (index) {
        final Time time = index as Time;
        setState(() {
          _selectedTime = TimeOfDay(hour: time.hours, minute: time.minutes);
        });
      },
      buttonSingleColor: AppColors.primary,
      backgroundColor: Colors.white,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '알림 설정',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '날씨 알림',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '매일 설정한 시간에 날씨와 추천 착장을 알려드립니다',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _isEnabled,
                onChanged: (value) {
                  setState(() {
                    _isEnabled = value;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '알림 시간',
            style: theme.textTheme.titleMedium?.copyWith(
              color: _isEnabled ? null : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 12),
          Opacity(
            opacity: _isEnabled ? 1.0 : 0.5,
            child: InkWell(
              onTap: _isEnabled ? _selectTime : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isEnabled ? Colors.grey[300]! : Colors.grey[200]!,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: _isEnabled ? null : Colors.grey[50],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: _isEnabled ? AppColors.primary : Colors.grey[400],
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _selectedTime.format(context),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: _isEnabled ? null : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: _isEnabled ? Colors.grey[400] : Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '저장',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
