import 'package:flutter/material.dart';

/// Raw design tokens. Widgets never use these directly: they read colors
/// from `Theme.of(context).colorScheme` or the `AppColors` extension.
///
/// Light values are the approved "slate" palette from the UI spec.
/// Dark values are tonal counterparts from the same slate family.
abstract final class LightTokens {
  static const primary = Color(0xFF334155);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFDDE3EA);
  static const onPrimaryContainer = Color(0xFF111827);
  // A soft off-white page, so white cards stand out and less of the screen
  // glares (v0.2.0).
  static const surface = Color(0xFFEDF1F5);
  static const surfaceContainer = Color(0xFFE3E8EE);
  static const card = Color(0xFFFFFFFF);

  /// Every other row of a list (zebra), on [card].
  static const rowAlt = Color(0xFFF2F5F8);

  /// Card borders and dividers between rows.
  static const border = Color(0xFFD8DFE7);
  static const onSurface = Color(0xFF0F172A);
  static const onSurfaceVariant = Color(0xFF475569);
  static const outline = Color(0xFFAEB7C2);
  static const success = Color(0xFF047857);
  static const successContainer = Color(0xFFD1FAE5);
  static const warning = Color(0xFF9A3412);
  static const warningContainer = Color(0xFFFFEDD5);
  static const error = Color(0xFFB3261E);
  static const errorContainer = Color(0xFFFDE2E0);
}

abstract final class DarkTokens {
  static const primary = Color(0xFFCBD5E1);
  static const onPrimary = Color(0xFF1E293B);
  static const primaryContainer = Color(0xFF334155);
  static const onPrimaryContainer = Color(0xFFE2E8F0);
  static const surface = Color(0xFF0F172A);
  static const surfaceContainer = Color(0xFF1E293B);
  static const card = Color(0xFF172033);
  static const rowAlt = Color(0xFF1C2840);
  static const border = Color(0xFF2A3754);
  static const onSurface = Color(0xFFF1F5F9);
  static const onSurfaceVariant = Color(0xFFA3B0C2);
  static const outline = Color(0xFF64748B);
  static const success = Color(0xFF6EE7B7);
  static const successContainer = Color(0xFF064E3B);
  static const warning = Color(0xFFFDBA74);
  static const warningContainer = Color(0xFF7C2D12);
  static const error = Color(0xFFF2B8B5);
  static const errorContainer = Color(0xFF8C1D18);
}

/// Shape tokens (dp).
abstract final class Radii {
  static const hero = 28.0;
  static const card = 20.0;
  static const chip = 10.0;
  static const field = 28.0;
}

/// Spacing on an 8dp grid.
abstract final class Space {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;

  /// Side padding of every page.
  static const page = 16.0;
}

/// Minimum touch target (Material).
const double kMinTouchTarget = 48;
