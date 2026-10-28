import 'dart:convert';

/// The server's rules for new accounts (owner-auth-api.md › Data rules),
/// checked on the phone first so owners see the problem right away.
abstract final class PersonName {
  static const minLength = 2;
  static const maxLength = 50;

  // Persian letters (with آ and ء-family forms), space and ZWNJ.
  static final _allowed = RegExp(
    '^[\u0621-\u063A\u0641-\u064A\u067E\u0686\u0698\u06A9\u06AF'
    '\u06CC\u06C0\u0622 \u200c]+'
    r'$',
  );

  /// The name as it will be sent: trimmed, single spaces, Arabic ي/ك as
  /// Persian ی/ک. Null when it breaks a rule.
  static String? normalize(String input) {
    final name = input
        .replaceAll('ي', 'ی')
        .replaceAll('ك', 'ک')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (name.length < minLength || name.length > maxLength) return null;
    return _allowed.hasMatch(name) ? name : null;
  }
}

/// A rule a new password breaks.
enum PasswordProblem {
  /// Fewer than [PasswordRules.minLength] characters.
  tooShort,

  /// Fewer than [PasswordRules.minDistinct] different characters.
  tooRepetitive,

  /// More than [PasswordRules.maxBytes] bytes (a Persian letter is 2).
  tooLong,

  /// On the list of passwords everyone tries first.
  tooCommon,
}

abstract final class PasswordRules {
  static const minLength = 8;
  static const maxBytes = 72;
  static const minDistinct = 4;

  // The server has the full list; these are the ones people try first.
  static const _common = {
    '1234567890',
    '0123456789',
    '12345678910',
    '1234567890a',
    'password123',
    'password1234',
    'admin123456',
    'qwertyuiop',
    'qwerty1234',
    'asdfghjkl1',
    '1q2w3e4r5t',
    'iloveyou12',
    '0912345678',
    'caspian123',
    'caspian1234',
  };

  /// Every rule [password] breaks, in the order they are shown.
  static Set<PasswordProblem> problems(String password) => {
    if (password.runes.length < minLength) PasswordProblem.tooShort,
    if (password.runes.toSet().length < minDistinct)
      PasswordProblem.tooRepetitive,
    if (utf8.encode(password).length > maxBytes) PasswordProblem.tooLong,
    if (_common.contains(password.toLowerCase())) PasswordProblem.tooCommon,
  };
}
