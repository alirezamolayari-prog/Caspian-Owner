import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:shamsi_date/shamsi_date.dart';

/// «۲۰ مهر ۱۴۰۵»
String formatJalaliDate(DateTime dateTime) {
  final f = Jalali.fromDateTime(dateTime.toLocal()).formatter;
  return toPersianDigits('${f.d} ${f.mN} ${f.yyyy}');
}

/// «۲۰ مهر»: date without the year, for recent items.
String formatJalaliDayMonth(DateTime dateTime) {
  final f = Jalali.fromDateTime(dateTime.toLocal()).formatter;
  return toPersianDigits('${f.d} ${f.mN}');
}

/// «۰۹:۰۵»: 24-hour time.
String formatTime(DateTime dateTime) {
  final local = dateTime.toLocal();
  final hh = local.hour.toString().padLeft(2, '0');
  final mm = local.minute.toString().padLeft(2, '0');
  return toPersianDigits('$hh:$mm');
}

/// «۲۰ مهر ۱۴۰۵ · ۰۹:۰۵»
String formatJalaliDateTime(DateTime dateTime) =>
    '${formatJalaliDate(dateTime)} · ${formatTime(dateTime)}';
