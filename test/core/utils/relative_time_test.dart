import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/utils/relative_time.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('fa'));
  final now = DateTime(2026, 10, 12, 15);

  String rel(DateTime t) => formatRelativeTime(t, now: now, l10n: l10n);

  test('under a minute is «همین الان»', () {
    expect(rel(now.subtract(const Duration(seconds: 30))), 'همین الان');
  });

  test('future timestamps (clock skew) read as now', () {
    expect(rel(now.add(const Duration(minutes: 2))), 'همین الان');
  });

  test('minutes', () {
    expect(rel(now.subtract(const Duration(minutes: 10))), '۱۰ دقیقه پیش');
  });

  test('hours on the same day', () {
    expect(rel(now.subtract(const Duration(hours: 3))), '۳ ساعت پیش');
  });

  test('previous calendar day is «دیروز»', () {
    expect(rel(DateTime(2026, 10, 11, 23)), 'دیروز');
  });

  test('days within a week', () {
    expect(rel(DateTime(2026, 10, 8, 12)), '۴ روز پیش');
  });

  test('older dates in the same Jalali year show day and month', () {
    expect(rel(DateTime(2026, 9, 2)), '۱۱ شهریور');
  });

  test('dates in an earlier Jalali year include the year', () {
    expect(rel(DateTime(2026, 3, 2)), '۱۱ اسفند ۱۴۰۴');
  });
}
