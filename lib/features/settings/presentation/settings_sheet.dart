import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/user_preferences.dart';
import '../../../core/providers/app_providers.dart';
import '../../shared/widgets/async_value_view.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferencesValue = ref.watch(userPreferencesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('개인화 설정'),
      ),
      body: AsyncValueView<UserPreferences>(
        value: preferencesValue,
        builder: (context, preferences) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '성별',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: GenderPreference.values.map((gender) {
                  return ChoiceChip(
                    label: Text(_genderLabel(gender)),
                    selected: preferences.gender == gender,
                    onSelected: (_) {
                      ref
                          .read(userPreferencesControllerProvider.notifier)
                          .updateGender(gender);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text(
                '체감 민감도',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SegmentedButton<TemperatureSensitivity>(
                segments: TemperatureSensitivity.values
                    .map(
                      (value) => ButtonSegment<TemperatureSensitivity>(
                        value: value,
                        label: Text(_sensitivityLabel(value)),
                      ),
                    )
                    .toList(),
                selected: {preferences.sensitivity},
                onSelectionChanged: (selection) {
                  final value = selection.first;
                  ref
                      .read(userPreferencesControllerProvider.notifier)
                      .updateSensitivity(value);
                },
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '설정은 자동으로 저장되며, 날씨 기반 옷차림 조언에 즉시 반영됩니다.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _genderLabel(GenderPreference gender) {
    switch (gender) {
      case GenderPreference.female:
        return '여성';
      case GenderPreference.male:
        return '남성';
      case GenderPreference.nonBinary:
        return '논바이너리';
      case GenderPreference.unspecified:
        return '선택 안함';
    }
  }

  String _sensitivityLabel(TemperatureSensitivity sensitivity) {
    switch (sensitivity) {
      case TemperatureSensitivity.runsCold:
        return '추위를 많이 타요';
      case TemperatureSensitivity.neutral:
        return '보통이에요';
      case TemperatureSensitivity.runsHot:
        return '더위를 많이 타요';
    }
  }
}
