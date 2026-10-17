// Draws the launcher icon from lib/core/brand/brand.dart and the theme
// tokens, as PNGs for flutter_launcher_icons. Not part of the test suite
// (it lives in tool/); run it by hand, see tool/brand/README.md.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:caspian_owner/core/brand/brand.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _size = 1024.0;
const _out = 'tool/brand/out';

/// Letter size and position, measured from its real ink (a font's line box
/// includes room for accents and descenders, so text "centered" in its box
/// sits off-center).
late double _fontSize;
late Offset _shift;

void main() {
  setUpAll(() async {
    final loader = FontLoader(Brand.fontFamily)
      ..addFont(rootBundle.load('assets/fonts/Vazirmatn-UI-FD-Bold.ttf'));
    await loader.load();
  });

  GlobalKey prepare(WidgetTester tester) {
    tester.view
      ..physicalSize = const Size(_size, _size)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    return GlobalKey();
  }

  Future<ui.Image> capture(
    WidgetTester tester,
    GlobalKey key,
    Widget child,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.rtl,
        child: RepaintBoundary(key: key, child: child),
      ),
    );
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    return (await tester.runAsync(boundary.toImage))!;
  }

  Future<void> save(WidgetTester tester, ui.Image image, String name) async {
    await tester.runAsync(() async {
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      final file = File('$_out/$name.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(png!.buffer.asUint8List());
    });
  }

  Widget letter(double fontSize, Offset shift) => SizedBox.square(
    dimension: _size,
    child: Center(
      child: Transform.translate(
        offset: shift,
        child: Text(
          Brand.iconGlyph,
          style: TextStyle(
            fontFamily: Brand.fontFamily,
            fontWeight: FontWeight.w700,
            fontSize: fontSize,
            height: 1,
            color: LightTokens.onPrimary,
          ),
        ),
      ),
    ),
  );

  testWidgets('measure the letter', (tester) async {
    const probe = 400.0;
    final image = await capture(
      tester,
      prepare(tester),
      letter(probe, Offset.zero),
    );
    final bytes = (await tester.runAsync(image.toByteData))!.buffer
        .asUint8List();
    var (minX, minY, maxX, maxY) = (_size, _size, 0.0, 0.0);
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        if (bytes[(y * image.width + x) * 4 + 3] > 0) {
          if (x < minX) minX = x.toDouble();
          if (x > maxX) maxX = x.toDouble();
          if (y < minY) minY = y.toDouble();
          if (y > maxY) maxY = y.toDouble();
        }
      }
    }
    final ink = Rect.fromLTRB(minX, minY, maxX + 1, maxY + 1);
    // The adaptive icon's safe zone is a circle of 66% of the canvas; keep
    // the letter's box well inside it.
    final scale = (_size * 0.42) / ink.longestSide;
    _fontSize = probe * scale;
    _shift = (const Offset(_size / 2, _size / 2) - ink.center) * scale;
  });

  testWidgets('adaptive foreground (also the monochrome icon)', (tester) async {
    final image = await capture(
      tester,
      prepare(tester),
      letter(_fontSize, _shift),
    );
    await save(tester, image, 'icon_foreground');
  });

  testWidgets('adaptive background', (tester) async {
    final image = await capture(
      tester,
      prepare(tester),
      const ColoredBox(
        color: LightTokens.primary,
        child: SizedBox.square(dimension: _size),
      ),
    );
    await save(tester, image, 'icon_background');
  });

  testWidgets('legacy icon (rounded square, Android 7)', (tester) async {
    const bigger = 1.3;
    final image = await capture(
      tester,
      prepare(tester),
      DecoratedBox(
        decoration: const BoxDecoration(
          color: LightTokens.primary,
          borderRadius: BorderRadius.all(Radius.circular(_size * 0.22)),
        ),
        child: letter(_fontSize * bigger, _shift * bigger),
      ),
    );
    await save(tester, image, 'icon');
  });
}
