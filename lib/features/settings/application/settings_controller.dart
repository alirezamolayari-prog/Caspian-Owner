import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Owner preferences. Defaults are the safe choices; the Settings screen
/// (M10) lets owners change and keep them.
class AppSettings {
  const new({this.fingerprintForApproval = true, this.secureScreens = true});

  /// «تأیید با اثر انگشت برای تأیید درخواست»: one touch before approving.
  final bool fingerprintForApproval;

  /// Block screenshots on stock, requests and counts (FLAG_SECURE).
  final bool secureScreens;

  AppSettings copyWith({bool? fingerprintForApproval, bool? secureScreens}) =>
      AppSettings(
        fingerprintForApproval:
            fingerprintForApproval ?? this.fingerprintForApproval,
        secureScreens: secureScreens ?? this.secureScreens,
      );
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => const AppSettings();

  void setFingerprintForApproval({required bool enabled}) =>
      state = state.copyWith(fingerprintForApproval: enabled);

  void setSecureScreens({required bool enabled}) =>
      state = state.copyWith(secureScreens: enabled);
}
