import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/weather_models.dart';
import '../../settings/presentation/settings_sheet.dart';
import '../../shared/widgets/async_value_view.dart';
import '../providers/weather_controller.dart';
import '../../../core/providers/app_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherControllerProvider);
    final locationOptions = ref.watch(locationOptionsProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: locationOptions.when(
          data: (options) {
            if (options.isEmpty) {
              return const Text('위치를 불러오는 중');
            }
            final selected = weatherState.value?.location;
            return _LocationSelector(
              options: options,
              selected: selected,
              onSelected: (location) {
                ref
                    .read(weatherControllerProvider.notifier)
                    .setLocation(location);
              },
            );
          },
          error: (error, stackTrace) => const Text('위치 선택 불가'),
          loading: () => const SizedBox(
            height: 28,
            width: 28,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsSheet.routeName);
            },
          ),
        ],
      ),
      body: AsyncValueView(
        value: weatherState,
        onRetry: () => ref.read(weatherControllerProvider.notifier).refresh(),
        builder: (context, data) {
          final bundle = data.bundle;
          final advice = data.advice;

          return RefreshIndicator(
            onRefresh: () => ref.read(weatherControllerProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _CurrentSummaryCard(bundle: bundle, adviceHeadline: advice.headline),
                const SizedBox(height: 16),
                _SuggestionChips(suggestions: advice.suggestions),
                const SizedBox(height: 24),
                _HourlyForecastSection(hourly: bundle.hourly),
                const SizedBox(height: 24),
                _WeeklyForecastSection(daily: bundle.daily),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LocationSelector extends StatelessWidget {
  const _LocationSelector({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<LocationPoint> options;
  final LocationPoint? selected;
  final ValueChanged<LocationPoint> onSelected;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedOption = selected != null &&
            options.any((element) => element == selected)
        ? selected!
        : options.first;

    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260),
      child: InkWell(
        onTap: () async {
          final result = await showModalBottomSheet<LocationPoint>(
            context: context,
            isScrollControlled: true,
            builder: (context) => _LocationSearchSheet(
              options: options,
              selected: selectedOption,
            ),
          );
          if (result != null) {
            onSelected(result);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  _locationLabel(selectedOption),
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.expand_more, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  String _locationLabel(LocationPoint location) {
    final parts = <String>[
      if (location.city.trim().isNotEmpty) location.city.trim(),
      if (location.district.trim().isNotEmpty) location.district.trim(),
    ];

    final label = parts.join(' ');
    if (label.isNotEmpty) {
      return label;
    }

    if (location.locality.trim().isNotEmpty) {
      return location.locality.trim();
    }

    return '${location.latitude.toStringAsFixed(2)}, ${location.longitude.toStringAsFixed(2)}';
  }
}

class _LocationSearchSheet extends StatefulWidget {
  const _LocationSearchSheet({
    required this.options,
    required this.selected,
  });

  final List<LocationPoint> options;
  final LocationPoint selected;

  @override
  State<_LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends State<_LocationSearchSheet> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late List<LocationPoint> _filtered;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _filtered = widget.options;
    _controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onQueryChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    final keyword = _controller.text.trim().toLowerCase();
    setState(() {
      if (keyword.isEmpty) {
        _filtered = widget.options;
      } else {
        _filtered = widget.options.where((option) {
          final searchTarget = [
            option.city,
            option.district,
            option.locality,
          ].join(' ').toLowerCase();
          return searchTarget.contains(keyword);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.7;

    return SafeArea(
      child: SizedBox(
        height: maxHeight,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: mediaQuery.viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '지역 선택',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '검색어를 입력하면 시/군/구 추천이 바로 표시돼요.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: '예: 강남, 부산, 제주',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _filtered.isEmpty
                    ? Center(
                        child: Text(
                          '검색 결과가 없습니다.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                    : ListView.separated(
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final option = _filtered[index];
                          final label = _locationLabel(option);
                          final isSelected = option == widget.selected;
                          return ListTile(
                            title: Text(label),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check,
                                    color: theme.colorScheme.primary,
                                  )
                                : null,
                            onTap: () => Navigator.of(context).pop(option),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _locationLabel(LocationPoint location) {
    final parts = <String>[
      if (location.city.trim().isNotEmpty) location.city.trim(),
      if (location.district.trim().isNotEmpty) location.district.trim(),
    ];

    final label = parts.join(' ');
    if (label.isNotEmpty) {
      return label;
    }

    if (location.locality.trim().isNotEmpty) {
      return location.locality.trim();
    }

    return '${location.latitude.toStringAsFixed(2)}, ${location.longitude.toStringAsFixed(2)}';
  }
}

class _CurrentSummaryCard extends StatelessWidget {
  const _CurrentSummaryCard({
    required this.bundle,
    required this.adviceHeadline,
  });

  final WeatherBundle bundle;
  final String adviceHeadline;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bundle.locationName,
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        adviceHeadline,
                        style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${bundle.current.temperatureC.round()}°',
                  style: textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _InfoChip(icon: Icons.thermostat, label: '체감 ${bundle.current.feelsLikeC.toStringAsFixed(1)}°C'),
                _InfoChip(icon: Icons.water_drop_outlined, label: '습도 ${bundle.current.humidityPercent.toStringAsFixed(0)}%'),
                _InfoChip(icon: Icons.air, label: '풍속 ${bundle.current.windSpeedKph.toStringAsFixed(0)}km/h'),
                _InfoChip(
                  icon: Icons.umbrella_outlined,
                  label: '강수 ${bundle.current.precipitationChance.toStringAsFixed(0)}%',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              bundle.current.conditionDescription,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

class _SuggestionChips extends StatelessWidget {
  const _SuggestionChips({required this.suggestions});

  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: suggestions
          .map(
            (tip) => Chip(
              label: Text(tip),
            ),
          )
          .toList(),
    );
  }
}

class _HourlyForecastSection extends StatelessWidget {
  const _HourlyForecastSection({required this.hourly});

  final List<WeatherSnapshot> hourly;

  @override
  Widget build(BuildContext context) {
    if (hourly.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '시간대별 옷차림 가이드',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: hourly.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = hourly[index];
              final time = TimeOfDay.fromDateTime(item.timestamp);

              return Container(
                width: 110,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${time.hour.toString().padLeft(2, '0')}:00'),
                    const Spacer(),
                    Text(
                      '${item.temperatureC.toStringAsFixed(0)}°',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '체감 ${item.feelsLikeC.toStringAsFixed(0)}°',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _WeeklyForecastSection extends StatelessWidget {
  const _WeeklyForecastSection({required this.daily});

  final List<DailyForecast> daily;

  @override
  Widget build(BuildContext context) {
    if (daily.isEmpty) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '7일간 옷차림 플랜',
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ...daily.map(
          (item) {
            final weekday = _weekdayLabel(item.date);
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Text(
                  weekday,
                  style: textTheme.titleMedium,
                ),
                title: Text('${item.minTempC.toStringAsFixed(0)}° / ${item.maxTempC.toStringAsFixed(0)}°'),
                subtitle: Text(item.clothingSummary.isNotEmpty
                    ? item.clothingSummary
                    : item.conditionDescription),
              ),
            );
          },
        ),
      ],
    );
  }

  String _weekdayLabel(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final index = date.weekday - 1;
    return weekdays[index % weekdays.length];
  }
}
