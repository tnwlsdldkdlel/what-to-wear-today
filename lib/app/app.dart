import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';
import 'themes/app_theme.dart';

class OutfitApp extends StatelessWidget {
  const OutfitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '오늘 뭐 입음?',
      theme: AppTheme.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      locale: const Locale('ko'),
      fallbackLocale: const Locale('en'),
    );
  }
}
