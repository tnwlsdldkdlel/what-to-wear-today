import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/themes/app_theme.dart';
import '../../../core/models/city_region.dart';
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const NotificationSettingsSheet(),
    );
  }

  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const LocationPickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => GestureDetector(
            onTap: () => _showLocationPicker(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(controller.areaLabel.value),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 24),
              ],
            ),
          ),
        ),
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
            return HomeContent(recommendation: data);
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

class HomeContent extends GetView<HomeController> {
  const HomeContent({
    super.key,
    required this.recommendation,
  });

  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeroWeatherCard(recommendation: recommendation),
        const SizedBox(height: 16),
        Obx(() {
          final popular = controller.popularOutfit.value;
          if (popular != null) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.justRight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.justRight.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: AppColors.accent,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      popular.buildRecommendationMessage(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
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
  });

  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _WeatherIcon(code: recommendation.weatherIcon),
            const SizedBox(height: 12),
            Text(
              '${recommendation.temperature.toStringAsFixed(1)}°',
              style: theme.textTheme.headlineSmall?.copyWith(fontSize: 40),
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
    final color = _getColorForWeather(code);
    return Icon(icon, color: color, size: 100);
  }

  IconData _mapToIcon(String code) {
    switch (code) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'partly_cloudy':
        return Icons.cloud;
      case 'rain':
      case 'heavy_rain':
        return Icons.grain;
      case 'fog':
        return Icons.blur_on;
      case 'snow':
      case 'heavy_snow':
        return Icons.ac_unit;
      case 'storm':
        return Icons.flash_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  Color _getColorForWeather(String code) {
    switch (code) {
      case 'sunny':
        return const Color(0xFFFFA726); // 오렌지 (맑음)
      case 'partly_cloudy':
        return const Color(0xFF90CAF9); // 하늘색 (구름 조금)
      case 'rain':
      case 'heavy_rain':
        return const Color(0xFF42A5F5); // 파란색 (비)
      case 'fog':
        return const Color(0xFF9E9E9E); // 회색 (안개)
      case 'snow':
      case 'heavy_snow':
        return const Color(0xFF81D4FA); // 연한 파란색 (눈)
      case 'storm':
        return const Color(0xFF5C6BC0); // 보라색 (폭풍)
      default:
        return const Color(0xFFBDBDBD); // 회색 (흐림)
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
  FixedExtentScrollController? _hourController;
  FixedExtentScrollController? _minuteController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _notificationService.loadSettings();
    if (mounted) {
      setState(() {
        _isEnabled = settings.isEnabled;
        _selectedTime = settings.notificationTime;
        _hourController = FixedExtentScrollController(
          initialItem: settings.notificationTime.hour,
        );
        _minuteController = FixedExtentScrollController(
          initialItem: settings.notificationTime.minute,
        );
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _hourController?.dispose();
    _minuteController?.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    // 알림이 활성화되는 경우 권한 요청
    if (_isEnabled) {
      final granted = await _notificationService.requestPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('알림 권한이 필요합니다. 설정에서 권한을 허용해주세요.'),
            ),
          );
        }
        return;
      }
    }

    final settings = NotificationSettings(
      isEnabled: _isEnabled,
      notificationTime: _selectedTime,
    );
    await _notificationService.saveSettings(settings);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEnabled
                ? '알림이 설정되었습니다. 매일 ${_selectedTime.format(context)}에 알림을 받으실 수 있습니다.'
                : '알림이 해제되었습니다.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(24),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
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
                activeTrackColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            '알림 시간',
            style: theme.textTheme.titleMedium?.copyWith(
              color: _isEnabled ? null : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Opacity(
              opacity: _isEnabled ? 1.0 : 0.5,
              child: IgnorePointer(
                ignoring: !_isEnabled,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isEnabled ? Colors.grey[300]! : Colors.grey[200]!,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: _isEnabled ? Colors.white : Colors.grey[50],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          controller: _hourController!,
                          itemExtent: 50,
                          perspective: 0.005,
                          diameterRatio: 1.2,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _selectedTime = TimeOfDay(
                                hour: index,
                                minute: _selectedTime.minute,
                              );
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 24,
                            builder: (context, index) {
                              final isSelected = index == _selectedTime.hour;
                              return Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontSize: isSelected ? 28 : 20,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.grey[400],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const Text(
                        ':',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          controller: _minuteController!,
                          itemExtent: 50,
                          perspective: 0.005,
                          diameterRatio: 1.2,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _selectedTime = TimeOfDay(
                                hour: _selectedTime.hour,
                                minute: index,
                              );
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 60,
                            builder: (context, index) {
                              final isSelected = index == _selectedTime.minute;
                              return Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontSize: isSelected ? 28 : 20,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.grey[400],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
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

class LocationPickerSheet extends StatefulWidget {
  const LocationPickerSheet({super.key});

  @override
  State<LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<LocationPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<CityRegion> _filteredRegions = CityRegion.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredRegions = CityRegion.search(query);
    });
  }

  void _onRegionSelected(CityRegion region) {
    final controller = Get.find<HomeController>();
    controller.selectRegion(region);
    Navigator.pop(context);
  }

  void _onCurrentLocationSelected() {
    final controller = Get.find<HomeController>();
    controller.useCurrentLocation();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '지역 선택',
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
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: '시/도 검색',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.my_location, color: AppColors.primary),
            title: const Text(
              '현재 위치',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            onTap: _onCurrentLocationSelected,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            tileColor: AppColors.primary.withOpacity(0.05),
          ),
          const SizedBox(height: 16),
          Text(
            '전체 지역',
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filteredRegions.isEmpty
                ? Center(
                    child: Text(
                      '검색 결과가 없습니다',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredRegions.length,
                    itemBuilder: (context, index) {
                      final region = _filteredRegions[index];
                      return ListTile(
                        title: Text(region.name),
                        onTap: () => _onRegionSelected(region),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
