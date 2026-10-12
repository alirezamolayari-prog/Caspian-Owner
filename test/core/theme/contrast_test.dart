import 'package:caspian_owner/core/theme/app_colors.dart';
import 'package:caspian_owner/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// WCAG 2 contrast ratio between two opaque colors.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  void checkText(String theme, ColorScheme s, AppColors c) {
    // Every pair where normal-size text sits on a background.
    final pairs = <String, (Color, Color)>{
      'onSurface / surface': (s.onSurface, s.surface),
      'onSurface / card': (s.onSurface, c.card),
      'onSurface / surfaceContainer': (s.onSurface, s.surfaceContainer),
      'onSurfaceVariant / surface': (s.onSurfaceVariant, s.surface),
      'onSurfaceVariant / card': (s.onSurfaceVariant, c.card),
      'onSurfaceVariant / surfaceContainer': (
        s.onSurfaceVariant,
        s.surfaceContainer,
      ),
      'onPrimary / primary': (s.onPrimary, s.primary),
      'onPrimaryContainer / primaryContainer': (
        s.onPrimaryContainer,
        s.primaryContainer,
      ),
      'primary / surface (text buttons)': (s.primary, s.surface),
      'primary / card (text buttons)': (s.primary, c.card),
      'error / surface (reject button text)': (s.error, s.surface),
      'onErrorContainer / errorContainer': (
        s.onErrorContainer,
        s.errorContainer,
      ),
      'success / successContainer': (c.success, c.successContainer),
      'warning / warningContainer': (c.warning, c.warningContainer),
      'onError / error': (s.onError, s.error),
    };
    for (final MapEntry(key: name, value: (fg, bg)) in pairs.entries) {
      test('$theme: $name ≥ 4.5:1', () {
        expect(contrast(fg, bg), greaterThanOrEqualTo(4.5));
      });
    }
  }

  group('light', () {
    checkText('light', AppTheme.lightScheme, AppColors.light);
  });

  group('dark', () {
    checkText('dark', AppTheme.darkScheme, AppColors.dark);
  });
}
