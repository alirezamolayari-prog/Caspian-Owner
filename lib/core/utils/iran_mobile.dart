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

  /// Shown as «۰۹۱۲ ۳۴۵ ۶۷۸۹» (Persian digits, grouped).
  static String display(String mobile) => toPersianDigits(
    mobile.length == 11
        ? '${mobile.substring(0, 4)} ${mobile.substring(4, 7)} '
              '${mobile.substring(7)}'
        : mobile,
  );
}
