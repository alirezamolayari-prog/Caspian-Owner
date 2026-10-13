import 'package:flutter_test/flutter_test.dart';

import '../../tool/make_update_manifest.dart';

void main() {
  test('reads version and build from pubspec', () {
    expect(readVersion('name: x\nversion: 1.2.0+12\n'), ('1.2.0', 12));
    expect(() => readVersion('name: x'), throwsFormatException);
  });

  test('takes only the matching changelog section', () {
    const changelog = '''
# تغییرات

## 1.2.0 (2026-10-13)
- رفع اشکال تأیید
- گزارش تازه

## 1.1.0
- نسخه قبلی
''';
    expect(
      changelogSection(changelog, '1.2.0'),
      '- رفع اشکال تأیید\n- گزارش تازه',
    );
    expect(changelogSection(changelog, '1.1.0'), '- نسخه قبلی');
    expect(changelogSection(changelog, '9.9.9'), '');
  });

  test('builds the contract shape and guards the minimum build', () {
    final m = buildManifest(
      version: '1.2.0',
      build: 12,
      minSupportedBuild: 9,
      apkUrl: 'https://example.org/a.apk',
      sha256Hex: 'a' * 64,
      sizeBytes: 100,
      changelogFa: '- x',
      publishedAt: DateTime.utc(2026, 10, 13),
    );
    expect(
      m.keys,
      containsAll([
        'version',
        'build',
        'min_supported_build',
        'apk_url',
        'sha256',
        'size_bytes',
        'changelog_fa',
        'published_at',
      ]),
    );
    expect(
      () => buildManifest(
        version: '1.2.0',
        build: 12,
        minSupportedBuild: 13,
        apkUrl: 'https://example.org/a.apk',
        sha256Hex: 'a' * 64,
        sizeBytes: 100,
        changelogFa: '',
        publishedAt: DateTime.utc(2026),
      ),
      throwsArgumentError,
    );
  });
}
