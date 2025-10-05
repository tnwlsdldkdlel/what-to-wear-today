import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/home/presentation/home_page.dart';
import '../features/settings/presentation/settings_sheet.dart';

class WearTodayApp extends ConsumerWidget {
  const WearTodayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF3B82F6));

    return MaterialApp(
      title: '오늘 뭐 입음?',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: colorScheme.surface,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: colorScheme.onSurface,
              displayColor: colorScheme.onSurface,
            ),
      ),
      home: const HomePage(),
      onGenerateRoute: (settings) {
        if (settings.name == SettingsSheet.routeName) {
          return MaterialPageRoute<void>(
            builder: (_) => const SettingsSheet(),
            settings: settings,
            fullscreenDialog: true,
          );
        }
        return null;
      },
    );
  }
}
