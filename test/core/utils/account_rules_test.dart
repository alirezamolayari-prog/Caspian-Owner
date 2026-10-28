import 'package:caspian_owner/core/utils/iran_mobile.dart';
import 'package:caspian_owner/features/auth/domain/account_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mobile', () {
    test('every accepted form becomes 09…', () {
      for (final input in [
        '09123456789',
        '9123456789',
        '+989123456789',
        '00989123456789',
        '۰۹۱۲۳۴۵۶۷۸۹',
        '٠٩١٢٣٤٥٦٧٨٩',
        '0912 345 6789',
        '0912-345-6789',
        ' +98 912 345 6789 ',
      ]) {
        expect(IranMobile.normalize(input), '09123456789', reason: input);
      }
    });

    test('anything else is refused', () {
      for (final input in [
        '',
        '0912345678',
        '091234567890',
        '02112345678',
        '989123456789',
        '+9809123456789',
        'abc',
        '0912345678x',
      ]) {
        expect(IranMobile.normalize(input), isNull, reason: input);
      }
    });

    test('is shown grouped with Persian digits, left to right', () {
      expect(
        IranMobile.display('09123456789'),
        '${IranMobile.ltrIsolate}۰۹۱۲ ۳۴۵ ۶۷۸۹${IranMobile.popIsolate}',
      );
    });
  });

  group('names', () {
    test('Persian letters, spaces and ZWNJ; ي/ك become ی/ک', () {
      expect(PersonName.normalize('  مهدی  '), 'مهدی');
      expect(PersonName.normalize('علي   اكبر'), 'علی اکبر');
      expect(PersonName.normalize('میر\u200cمحمدی'), 'میر\u200cمحمدی');
      expect(PersonName.normalize('آرش'), 'آرش');
    });

    test('Latin letters, digits, too short or too long are refused', () {
      expect(PersonName.normalize('Mehdi'), isNull);
      expect(PersonName.normalize('مهدی۲'), isNull);
      expect(PersonName.normalize('م'), isNull);
      expect(PersonName.normalize('م' * 51), isNull);
      expect(PersonName.normalize('م' * 50), isNotNull);
    });
  });

  group('passwords', () {
    test('a good password breaks no rule', () {
      expect(PasswordRules.problems('my-own-strong-pass'), isEmpty);
      expect(PasswordRules.problems('رمز خوب من ۱۲'), isEmpty);
    });

    test('8 characters are enough, 7 are not', () {
      expect(PasswordRules.problems('abcd1234'), isEmpty);
      expect(PasswordRules.problems('abc1234'), {PasswordProblem.tooShort});
    });

    test('each rule is reported', () {
      expect(
        PasswordRules.problems('abc12'),
        contains(PasswordProblem.tooShort),
      );
      expect(PasswordRules.problems('aaaaabbbbb'), {
        PasswordProblem.tooRepetitive,
      });
      expect(
        PasswordRules.problems('ر' * 37),
        contains(PasswordProblem.tooLong),
      );
      expect(
        PasswordRules.problems('ر' * 36),
        isNot(contains(PasswordProblem.tooLong)),
      );
      expect(PasswordRules.problems('Password123'), {
        PasswordProblem.tooCommon,
      });
    });
  });
}
