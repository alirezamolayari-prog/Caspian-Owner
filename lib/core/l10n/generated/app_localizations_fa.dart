// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'مالک کاسپین';

  @override
  String get retry => 'تلاش دوباره';

  @override
  String lastUpdated(String time) {
    return 'آخرین به‌روزرسانی: $time';
  }

  @override
  String get justNow => 'همین الان';

  @override
  String minutesAgo(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString دقیقه پیش';
  }

  @override
  String hoursAgo(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString ساعت پیش';
  }

  @override
  String get yesterday => 'دیروز';

  @override
  String daysAgo(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString روز پیش';
  }

  @override
  String get statusPending => 'منتظر';

  @override
  String get statusApproved => 'تأیید شد';

  @override
  String get statusRejected => 'رد شد';

  @override
  String get statusCancelled => 'لغو شد';

  @override
  String get lowStock => 'کم';
}
