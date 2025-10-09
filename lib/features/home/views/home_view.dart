import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/themes/app_theme.dart';
import '../../../core/models/recommendation.dart';
import '../../shared/widgets/async_value_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘 뭐 입음?'),
        actions: [
          IconButton(
            onPressed: controller.fetchRecommendation,
            icon: const Icon(Icons.refresh),
            tooltip: '새로고침',
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
        onPressed: () => Get.toNamed(AppRoutes.submission),
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
