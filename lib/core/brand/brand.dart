/// Every brand-specific value lives here (plus the Android label in
/// `android/app/src/main/res/values/strings.xml`). Renaming the product for
/// another mall must be a change to these two files only.
///
/// Colors are the brand palette in `lib/core/theme/tokens.dart`.
abstract final class Brand {
  /// App name shown in the UI and the task switcher.
  static const appNameFa = 'مالک کاسپین';
  static const appNameEn = 'Caspian Owner';

  /// Short name used as the large Home title.
  static const shortNameFa = 'کاسپین';

  /// Mall the app is built for.
  static const mallNameFa = 'پاساژ بازار مبل کاسپین';

  /// Support contact shown in About. Fictional placeholder until set.
  static const supportContactFa = 'پشتیبانی: مدیر سیستم';

  /// Copyright line shown in About and in LICENSE.
  static const copyrightHolder = 'Alireza Molayari';
  static const copyrightYear = 2026;
  static String get copyrightLine =>
      'Copyright (c) $copyrightYear $copyrightHolder. All rights reserved.';

  /// Font family bundled in `assets/fonts/` (declared in pubspec.yaml).
  static const fontFamily = 'Vazirmatn';

  /// GitHub repo used for update manifests and releases.
  static const releaseRepo = 'alirezamolayari-prog/Caspian-Owner';
}
