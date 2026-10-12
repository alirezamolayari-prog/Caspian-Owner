import 'package:caspian_owner/core/utils/jalali.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // 2026-10-12 (Gregorian) is 20 Mehr 1405.
  final date = DateTime(2026, 10, 12, 9, 5);

  test('formats a Jalali date with Persian digits', () {
    expect(formatJalaliDate(date), '۲۰ مهر ۱۴۰۵');
  });

  test('formats day and month only', () {
    expect(formatJalaliDayMonth(date), '۲۰ مهر');
  });

  test('formats 24-hour time with leading zeros', () {
    expect(formatTime(date), '۰۹:۰۵');
  });

  test('formats date and time', () {
    expect(formatJalaliDateTime(date), '۲۰ مهر ۱۴۰۵ · ۰۹:۰۵');
  });

  test('handles Nowruz (1 Farvardin)', () {
    expect(formatJalaliDate(DateTime(2026, 3, 21)), '۱ فروردین ۱۴۰۵');
  });
}
