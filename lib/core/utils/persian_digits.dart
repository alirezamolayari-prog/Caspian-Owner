import 'package:intl/intl.dart';

const _latin = '0123456789';
const _persian = '۰۱۲۳۴۵۶۷۸۹';
const _arabic = '٠١٢٣٤٥٦٧٨٩';

/// Replaces Latin (and Arabic-Indic) digits with Persian digits.
String toPersianDigits(String input) {
  final out = StringBuffer();
  for (final rune in input.runes) {
    final ch = String.fromCharCode(rune);
    final latin = _latin.indexOf(ch);
    final arabic = _arabic.indexOf(ch);
    if (latin >= 0) {
      out.write(_persian[latin]);
    } else if (arabic >= 0) {
      out.write(_persian[arabic]);
    } else {
      out.write(ch);
    }
  }
  return out.toString();
}

/// Replaces Persian and Arabic-Indic digits with Latin digits, for parsing
/// what users type (for example a phone number or an OTP code).
String toLatinDigits(String input) {
  final out = StringBuffer();
  for (final rune in input.runes) {
    final ch = String.fromCharCode(rune);
    final persian = _persian.indexOf(ch);
    final arabic = _arabic.indexOf(ch);
    if (persian >= 0) {
      out.write(_latin[persian]);
    } else if (arabic >= 0) {
      out.write(_latin[arabic]);
    } else {
      out.write(ch);
    }
  }
  return out.toString();
}

final NumberFormat _number = NumberFormat.decimalPattern('fa');

/// Formats a number with Persian digits and the Persian group separator,
/// e.g. 12500 → «۱۲٬۵۰۰».
String formatNumber(num value) => toPersianDigits(_number.format(value));
