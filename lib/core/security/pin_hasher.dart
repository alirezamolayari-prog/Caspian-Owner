import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Salted, iterated SHA-256 for the app PIN. The PIN itself is never stored.
abstract final class PinHasher {
  static const _iterations = 20000;

  static String newSalt([Random? random]) {
    final r = random ?? Random.secure();
    return base64Encode(List<int>.generate(16, (_) => r.nextInt(256)));
  }

  static String hash(String pin, String salt) {
    List<int> digest = utf8.encode('$salt:$pin');
    for (var i = 0; i < _iterations; i++) {
      digest = sha256.convert(digest).bytes;
    }
    return base64Encode(digest);
  }
}
