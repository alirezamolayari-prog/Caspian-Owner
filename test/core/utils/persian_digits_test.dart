import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('toPersianDigits', () {
    test('converts Latin digits', () {
      expect(toPersianDigits('0123456789'), '۰۱۲۳۴۵۶۷۸۹');
    });

    test('converts Arabic-Indic digits', () {
      expect(toPersianDigits('٠١٢٣٤٥٦٧٨٩'), '۰۱۲۳۴۵۶۷۸۹');
    });

    test('keeps other text', () {
      expect(toPersianDigits('پلاک 68'), 'پلاک ۶۸');
    });
  });

  group('toLatinDigits', () {
    test('converts Persian and Arabic-Indic digits', () {
      expect(toLatinDigits('۱۱۱۱۱'), '11111');
      expect(toLatinDigits('٠٩١٢'), '0912');
    });

    test('round-trips', () {
      expect(toLatinDigits(toPersianDigits('09121234567')), '09121234567');
    });
  });

  group('formatNumber', () {
    test('uses Persian digits and group separator', () {
      expect(formatNumber(3), '۳');
      expect(formatNumber(12500), '۱۲٬۵۰۰');
      expect(formatNumber(1250000), '۱٬۲۵۰٬۰۰۰');
    });
  });
}
