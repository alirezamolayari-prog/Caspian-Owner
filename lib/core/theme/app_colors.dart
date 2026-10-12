import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Colors Material's [ColorScheme] has no slot for: success, warning and the
/// white card surface. Read with `AppColors.of(context)`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const new({
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.card,
  });

  static const light = AppColors(
    success: LightTokens.success,
    successContainer: LightTokens.successContainer,
    warning: LightTokens.warning,
    warningContainer: LightTokens.warningContainer,
    card: LightTokens.card,
  );

  static const dark = AppColors(
    success: DarkTokens.success,
    successContainer: DarkTokens.successContainer,
    warning: DarkTokens.warning,
    warningContainer: DarkTokens.warningContainer,
    card: DarkTokens.card,
  );

  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;
  final Color card;

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith({
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? card,
  }) {
    return AppColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      card: card ?? this.card,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      card: Color.lerp(card, other.card, t)!,
    );
  }
}
