import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/utils/jalali.dart';
import 'package:shamsi_date/shamsi_date.dart';

/// Human relative time: «همین الان», «۱۰ دقیقه پیش», «۳ ساعت پیش»,
/// «دیروز», «۴ روز پیش», then a Jalali date («۲۰ مهر») after a week,
/// with the year added once it is a different Jalali year.
String formatRelativeTime(
  DateTime time, {
  required DateTime now,
  required AppLocalizations l10n,
}) {
  final t = time.toLocal();
  final n = now.toLocal();
  final diff = n.difference(t);

  // Future timestamps (clock skew between phone and server) read as "now".
  if (diff.inSeconds < 60) return l10n.justNow;
  if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes);

  final today = DateTime(n.year, n.month, n.day);
  final day = DateTime(t.year, t.month, t.day);
  final calendarDays = today.difference(day).inDays;

  if (calendarDays == 0) return l10n.hoursAgo(diff.inHours);
  if (calendarDays == 1) return l10n.yesterday;
  if (calendarDays < 7) return l10n.daysAgo(calendarDays);

  final sameYear = Jalali.fromDateTime(t).year == Jalali.fromDateTime(n).year;
  return sameYear ? formatJalaliDayMonth(t) : formatJalaliDate(t);
}
