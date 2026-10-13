import 'dart:io';

import 'package:caspian_owner/core/update/apk_downloader.dart';
import 'package:caspian_owner/core/update/update_checker.dart';
import 'package:caspian_owner/core/update/update_manifest.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_http.dart';

const _apkUrl = 'https://example.org/caspian-owner-1.2.0.apk';

Map<String, Object?> manifestJson({
  int build = 12,
  int minBuild = 9,
  String? sha,
  String url = _apkUrl,
  int size = 0,
}) => {
  'version': '1.2.0',
  'build': build,
  'min_supported_build': minBuild,
  'apk_url': url,
  'sha256': sha ?? 'a' * 64,
  'size_bytes': size,
  'changelog_fa': '- رفع اشکال',
  'published_at': '2026-10-13T08:00:00Z',
};

UpdateManifest manifestFor(List<int> bytes) => UpdateManifest.fromJson(
  manifestJson(sha: sha256.convert(bytes).toString(), size: bytes.length),
);

void main() {
  group('manifest', () {
    test('parses the contract shape', () {
      final m = UpdateManifest.fromJson(manifestJson());
      expect(m.build, 12);
      expect(m.minSupportedBuild, 9);
      expect(m.changelogFa, '- رفع اشکال');
    });

    test('rejects a bad checksum or a non-HTTPS APK', () {
      expect(
        () => UpdateManifest.fromJson(manifestJson(sha: 'xyz')),
        throwsFormatException,
      );
      expect(
        () => UpdateManifest.fromJson(
          manifestJson(url: 'http://example.org/a.apk'),
        ),
        throwsFormatException,
      );
    });
  });

  group('decision', () {
    final m = UpdateManifest.fromJson(manifestJson());

    test('newer build → optional', () {
      expect(
        decideUpdate(currentBuild: 10, manifest: m),
        isA<OptionalUpdate>(),
      );
    });

    test('same build → nothing', () {
      expect(decideUpdate(currentBuild: 12, manifest: m), isA<NoUpdate>());
    });

    test('below min_supported_build → required (blocking)', () {
      expect(decideUpdate(currentBuild: 8, manifest: m), isA<RequiredUpdate>());
    });

    test('no manifest → nothing', () {
      expect(decideUpdate(currentBuild: 1, manifest: null), isA<NoUpdate>());
    });
  });

  group('checker', () {
    test('falls back to the next URL and skips bad manifests', () async {
      final adapter = FakeHttpAdapter({
        'https://server.example/v1/app/update': (o) =>
            FakeHttpAdapter.json(manifestJson(sha: 'bad')),
        'https://github.example/update.json': (o) =>
            FakeHttpAdapter.json(manifestJson(build: 20)),
      });
      final checker = UpdateChecker(
        dio: fakeDio(adapter),
        urls: const [
          'https://down.example/update.json',
          'https://server.example/v1/app/update',
          'https://github.example/update.json',
        ],
      );
      final m = await checker.fetch();
      expect(m!.build, 20);
      expect(adapter.requests, hasLength(3));
    });

    test('nothing answers → null, quietly', () async {
      final checker = UpdateChecker(
        dio: fakeDio(FakeHttpAdapter({})),
        urls: const ['https://down.example/update.json'],
      );
      expect(await checker.fetch(), isNull);
    });

    test('default URLs end with the GitHub release asset', () {
      expect(
        manifestUrls().last,
        'https://github.com/alirezamolayari-prog/Caspian-Owner'
        '/releases/latest/download/update.json',
      );
    });
  });

  group('downloader', () {
    late Directory dir;
    final bytes = List<int>.generate(5000, (i) => i % 251);

    setUp(() => dir = Directory.systemTemp.createTempSync('caspian_apk_'));
    tearDown(() => dir.deleteSync(recursive: true));

    ApkDownloader downloader(FakeHttpAdapter adapter) =>
        ApkDownloader(directory: dir, dio: fakeDio(adapter), retries: 2);

    test('downloads, verifies and reports progress', () async {
      final adapter = FakeHttpAdapter({_apkUrl: FakeHttpAdapter.file(bytes)});
      final progress = <int>[];
      final apk = await downloader(adapter)
          .download(manifestFor(bytes), onProgress: (r, _) => progress.add(r));
      expect(apk.readAsBytesSync(), bytes);
      expect(progress.last, bytes.length);
    });

    test('a corrupted file is deleted and reported', () async {
      final adapter = FakeHttpAdapter({
        _apkUrl: FakeHttpAdapter.file([...bytes]..[10] = 0),
      });
      await expectLater(
        downloader(adapter).download(manifestFor(bytes)),
        throwsA(isA<ApkChecksumException>()),
      );
      expect(dir.listSync(), isEmpty);
    });

    test('resumes a partial download with a Range request', () async {
      final m = manifestFor(bytes);
      final d = downloader(
        FakeHttpAdapter({_apkUrl: FakeHttpAdapter.file(bytes)}),
      );
      File('${d.apkFile(m).path}.part')
          .writeAsBytesSync(bytes.sublist(0, 2000));
      final adapter = FakeHttpAdapter({_apkUrl: FakeHttpAdapter.file(bytes)});
      final apk = await downloader(adapter).download(m);
      expect(apk.readAsBytesSync(), bytes);
      expect(adapter.requests.single.headers['range'], 'bytes=2000-');
    });

    test('a server that ignores Range makes it start over', () async {
      final m = manifestFor(bytes);
      final adapter = FakeHttpAdapter({
        _apkUrl: FakeHttpAdapter.file(bytes, ignoreRange: true),
      });
      final d = downloader(adapter);
      File('${d.apkFile(m).path}.part')
          .writeAsBytesSync(bytes.sublist(0, 2000));
      final apk = await d.download(m);
      expect(apk.readAsBytesSync(), bytes);
      expect(adapter.requests, hasLength(2));
    });

    test('removes older APKs after a good download', () async {
      File('${dir.path}/caspian-owner-3.apk').writeAsStringSync('old');
      File('${dir.path}/caspian-owner-4.apk.part').writeAsStringSync('old');
      final adapter = FakeHttpAdapter({_apkUrl: FakeHttpAdapter.file(bytes)});
      final apk = await downloader(adapter).download(manifestFor(bytes));
      expect(dir.listSync().map((f) => f.uri.pathSegments.last), [
        apk.uri.pathSegments.last,
      ]);
    });

    test('network failure after the retries is reported', () async {
      final d = ApkDownloader(
        directory: dir,
        dio: fakeDio(FakeHttpAdapter({})),
        retries: 1,
      );
      await expectLater(
        d.download(manifestFor(bytes)),
        throwsA(isA<DioException>()),
      );
    });
  });
}
