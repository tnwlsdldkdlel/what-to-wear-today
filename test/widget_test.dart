// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:what_to_wear_today/app/app.dart';
import 'package:what_to_wear_today/core/models/weather_models.dart';
import 'package:what_to_wear_today/core/providers/app_providers.dart';

void main() {
  testWidgets('위치 선택 버튼과 바텀시트가 노출된다', (WidgetTester tester) async {
    const testLocation = LocationPoint(
      latitude: 37.5,
      longitude: 127.0,
      locality: '테스트 위치',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationPointProvider.overrideWith((ref) async => testLocation),
        ],
        child: const WearTodayApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('테스트 위치'), findsOneWidget);

    await tester.tap(find.text('테스트 위치'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('지역 선택'), findsOneWidget);
    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, '강남');
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('서울특별시 강남구'), findsOneWidget);
  });
}
