import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';
import '../../helpers/theme_sample.dart';

const _phone = Size(360, 720);

Widget _app(ThemeMode mode) => SizedBox.fromSize(
  size: _phone,
  child: themedApp(const ThemeSample(), themeMode: mode),
);

void main() {
  unawaited(
    goldenTest(
      'theme sample in light and dark',
      fileName: 'theme_sample',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(name: 'light', child: _app(ThemeMode.light)),
          GoldenTestScenario(name: 'dark', child: _app(ThemeMode.dark)),
        ],
      ),
    ),
  );

  testWidgets('layout is right-to-left', (tester) async {
    await tester.pumpWidget(themedApp(const ThemeSample()));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(ThemeSample));
    expect(Directionality.of(context), TextDirection.rtl);
    expect(Localizations.localeOf(context), const Locale('fa'));
  });

  testWidgets('largest system font scale renders without overflow', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(1080, 2160)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(themedApp(const ThemeSample()));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('buttons meet the 48dp touch target', (tester) async {
    await tester.pumpWidget(themedApp(const ThemeSample()));
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  });
}
