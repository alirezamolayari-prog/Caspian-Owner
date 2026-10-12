import 'package:caspian_owner/core/brand/brand.dart';
import 'package:caspian_owner/core/theme/app_colors.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Light and dark [ThemeData] built from the same tokens.
abstract final class AppTheme {
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: LightTokens.primary,
    onPrimary: LightTokens.onPrimary,
    primaryContainer: LightTokens.primaryContainer,
    onPrimaryContainer: LightTokens.onPrimaryContainer,
    secondary: LightTokens.primary,
    onSecondary: LightTokens.onPrimary,
    secondaryContainer: LightTokens.primaryContainer,
    onSecondaryContainer: LightTokens.onPrimaryContainer,
    error: LightTokens.error,
    onError: LightTokens.onPrimary,
    errorContainer: LightTokens.errorContainer,
    onErrorContainer: LightTokens.error,
    surface: LightTokens.surface,
    onSurface: LightTokens.onSurface,
    onSurfaceVariant: LightTokens.onSurfaceVariant,
    surfaceContainerLowest: LightTokens.card,
    surfaceContainerLow: LightTokens.card,
    surfaceContainer: LightTokens.surfaceContainer,
    surfaceContainerHigh: LightTokens.surfaceContainer,
    surfaceContainerHighest: LightTokens.primaryContainer,
    outline: LightTokens.outline,
    outlineVariant: LightTokens.surfaceContainer,
  );

  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: DarkTokens.primary,
    onPrimary: DarkTokens.onPrimary,
    primaryContainer: DarkTokens.primaryContainer,
    onPrimaryContainer: DarkTokens.onPrimaryContainer,
    secondary: DarkTokens.primary,
    onSecondary: DarkTokens.onPrimary,
    secondaryContainer: DarkTokens.primaryContainer,
    onSecondaryContainer: DarkTokens.onPrimaryContainer,
    error: DarkTokens.error,
    onError: DarkTokens.onPrimary,
    errorContainer: DarkTokens.errorContainer,
    onErrorContainer: DarkTokens.error,
    surface: DarkTokens.surface,
    onSurface: DarkTokens.onSurface,
    onSurfaceVariant: DarkTokens.onSurfaceVariant,
    surfaceContainerLowest: DarkTokens.card,
    surfaceContainerLow: DarkTokens.card,
    surfaceContainer: DarkTokens.surfaceContainer,
    surfaceContainerHigh: DarkTokens.surfaceContainer,
    surfaceContainerHighest: DarkTokens.primaryContainer,
    outline: DarkTokens.outline,
    outlineVariant: DarkTokens.surfaceContainer,
  );

  static ThemeData get light => _build(lightScheme, AppColors.light);
  static ThemeData get dark => _build(darkScheme, AppColors.dark);

  /// Type scale from the UI spec: title 24–26 bold, section 16 semibold,
  /// body 15, secondary 13, minimum 12. Persian script needs taller lines.
  static TextTheme _textTheme(ColorScheme s) {
    TextStyle style(double size, FontWeight weight, {double height = 1.5}) =>
        TextStyle(
          fontFamily: Brand.fontFamily,
          fontSize: size,
          fontWeight: weight,
          height: height,
          color: s.onSurface,
        );
    return TextTheme(
      displaySmall: style(32, FontWeight.w700, height: 1.3),
      headlineMedium: style(26, FontWeight.w700, height: 1.35),
      headlineSmall: style(24, FontWeight.w700, height: 1.35),
      titleLarge: style(20, FontWeight.w700, height: 1.4),
      titleMedium: style(16, FontWeight.w600),
      titleSmall: style(15, FontWeight.w600),
      bodyLarge: style(16, FontWeight.w400),
      bodyMedium: style(15, FontWeight.w400),
      bodySmall: style(13, FontWeight.w400).copyWith(color: s.onSurfaceVariant),
      labelLarge: style(15, FontWeight.w600),
      labelMedium: style(13, FontWeight.w500),
      labelSmall: style(12, FontWeight.w500),
    );
  }

  static ThemeData _build(ColorScheme s, AppColors colors) {
    final text = _textTheme(s);
    const stadium = StadiumBorder();
    const minButton = Size(kMinTouchTarget, kMinTouchTarget);
    const buttonPadding = EdgeInsets.symmetric(horizontal: Space.lg);

    return ThemeData(
      useMaterial3: true,
      colorScheme: s,
      fontFamily: Brand.fontFamily,
      textTheme: text,
      scaffoldBackgroundColor: s.surface,
      extensions: [colors],
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: s.surface,
        foregroundColor: s.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: colors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Radii.card)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: stadium,
          minimumSize: minButton,
          padding: buttonPadding,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: stadium,
          minimumSize: minButton,
          padding: buttonPadding,
          textStyle: text.labelLarge,
          side: BorderSide(color: s.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: stadium,
          minimumSize: minButton,
          textStyle: text.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: minButton),
      ),
      chipTheme: ChipThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Radii.chip)),
        ),
        labelStyle: text.labelMedium,
        side: BorderSide(color: s.outline),
        showCheckmark: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: s.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        indicatorColor: s.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(text.labelMedium),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: s.surfaceContainer,
        constraints: const BoxConstraints(minHeight: 56),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Space.md + Space.xs,
          vertical: Space.md,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(Radii.field)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(Radii.field)),
          borderSide: BorderSide(color: s.primary, width: 2),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.card,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.hero)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: text.bodyMedium?.copyWith(color: s.onPrimary),
      ),
      dividerTheme: DividerThemeData(color: s.outlineVariant, space: 1),
    );
  }
}
