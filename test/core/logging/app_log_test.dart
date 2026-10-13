import 'dart:io';

import 'package:caspian_owner/core/logging/app_log.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('caspian_log_'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('writes lines and keeps the recent ones in memory', () async {
    final log = AppLog(dir, minLevel: LogLevel.info)
      ..info('hello')
      ..debug('hidden');
    await log.flush();
    expect(log.recent.single, contains('INFO hello'));
    expect(log.files.single.readAsStringSync(), contains('hello'));
  });

  test('release level drops info lines', () async {
    final log = AppLog(dir, minLevel: LogLevel.warning)
      ..info('skip')
      ..error('boom', StateError('x'));
    await log.flush();
    expect(log.recent.single, contains('ERROR boom'));
    expect(log.recent.single, contains('Bad state: x'));
  });

  test('rotates files and keeps only the newest ones', () async {
    final log = AppLog(dir, maxBytes: 200);
    for (var i = 0; i < 40; i++) {
      log.info('line $i ${'x' * 40}');
    }
    await log.flush();
    expect(log.files.length, 3);
    expect(log.files.first.readAsStringSync(), contains('line 39'));
  });
}
