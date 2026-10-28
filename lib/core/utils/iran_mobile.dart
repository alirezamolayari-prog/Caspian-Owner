import 'package:caspian_owner/core/utils/persian_digits.dart';

/// Iranian mobile numbers, as Caspian Server accepts them.
abstract final class IranMobile {
  static final _separators = RegExp(r'[\s\-()\u200c\u200e\u200f]');
  static final _canonical = RegExp(r'^09\d{9}$');

  /// `09123456789` for any accepted form: `09…`, `9…`, `+989…`, `00989…`,
  /// with Persian or Arabic digits, spaces and dashes. Null otherwise.
  static String? normalize(String input) {
    var digits = toLatinDigits(input).replaceAll(_separators, '');
    if (digits.startsWith('+98')) {
      digits = '0${digits.substring(3)}';
    } else if (digits.startsWith('0098')) {
      digits = '0${digits.substring(4)}';
    } else if (digits.startsWith('9')) {
      digits = '0$digits';
    }
    return _canonical.hasMatch(digits) ? digits : null;
  }

  /// Shown as «۰۹۱۲ ۳۴۵ ۶۷۸۹» (Persian digits, grouped), inside a
  /// left-to-right isolate (LRI … PDI): in Persian text the groups would
  /// otherwise run right to left («۶۷۸۹ ۳۴۵ ۰۹۱۲»).
  static String display(String mobile) {
    final grouped = mobile.length == 11
        ? '${mobile.substring(0, 4)} ${mobile.substring(4, 7)} '
              '${mobile.substring(7)}'
        : mobile;
    return '$ltrIsolate${toPersianDigits(grouped)}$popIsolate';
  }

  /// Unicode LEFT-TO-RIGHT ISOLATE and POP DIRECTIONAL ISOLATE.
  static const ltrIsolate = '\u2066';
  static const popIsolate = '\u2069';
}
