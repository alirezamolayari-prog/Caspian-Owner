import 'dart:async';
import 'dart:io';

import 'package:caspian_owner/core/notifications/notification_poller.dart';
import 'package:caspian_owner/core/notifications/notification_providers.dart';
import 'package:caspian_owner/core/update/apk_downloader.dart';
import 'package:caspian_owner/core/update/apk_installer.dart';
import 'package:caspian_owner/core/update/update_checker.dart';
import 'package:caspian_owner/core/update/update_controller.dart';
import 'package:caspian_owner/core/update/update_manifest.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_http.dart';
import '../../helpers/test_app.dart';
import 'update_test.dart' show manifestJson;

class FakeInstaller implements ApkInstaller {
  bool allowed = true;
  bool fails = false;
  final installed = <String>[];
  int permissionPages = 0;

  @override
  Future<bool> canInstall() async => allowed;

  @override
  Future<void> openInstallPermission() async {
    permissionPages++;
  }

  @override
  Future<void> install(String apkPath) async {
    if (fails) throw Exception('no installer');
    installed.add(apkPath);
  }
}

/// Finishes when [finish] is called; no files are touched.
class FakeDownloader extends ApkDownloader {
  new() : super(directory: Directory('unused'));

  late Completer<File> _pending;
  int downloads = 0;

  void finish() => _pending.complete(File('/updates/caspian-owner-12.apk'));

  void fail() => _pending.completeError(Exception('network'));

  @override
  Future<File> download(
    UpdateManifest manifest, {
    void Function(int received, int total)? onProgress,
  }) {
    downloads++;
    onProgress?.call(50, 100);
    return (_pending = Completer<File>()).future;
  }
}

class FakeUpdateNotifier implements UpdateNotifier {
  final shown = <(String, bool)>[];

  @override
  Future<void> showUpdate({
    required String version,
    required bool ready,
    required String target,
  }) async {
    shown.add((version, ready));
  }
}

void main() {
  late TestHarness harness;
  late FakeInstaller installer;
  late FakeDownloader downloader;
  late FakeUpdateNotifier notifier;
  late ProviderContainer container;

  setUp(() async {
    harness = await TestHarness.load(signedIn: true);
    installer = FakeInstaller();
    downloader = FakeDownloader();
    notifier = FakeUpdateNotifier();
    container = harness.container(
      extra: [
        updateCheckerProvider.overrideWithValue(
          UpdateChecker(
            dio: fakeDio(
              FakeHttpAdapter({
                'https://u.example/update.json': (o) =>
                    FakeHttpAdapter.json(manifestJson(minBuild: 1)),
              }),
            ),
            urls: const ['https://u.example/update.json'],
          ),
        ),
        apkInstallerProvider.overrideWithValue(installer),
        apkDownloaderProvider.overrideWith((ref) async => downloader),
        updateNotifierProvider.overrideWithValue(notifier),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await harness.database.close();
  });

  UpdateController controller() =>
      container.read(updateControllerProvider.notifier);
  UpdateState state() => container.read(updateControllerProvider);

  test('a newer build is available (bell, About)', () async {
    await controller().check();
    expect(state().decision, isA<OptionalUpdate>());
    expect(container.read(availableUpdateProvider)?.version, '1.2.0');
  });

  test('installs right away when the app is in front; a second tap while '
      'downloading does nothing', () async {
    await controller().check();
    final run = controller().downloadAndInstall();
    await pumpEventQueue();
    expect(state().downloading, isTrue);
    expect(state().progress, 0.5);
    await controller().downloadAndInstall();
    expect(downloader.downloads, 1);

    downloader.finish();
    await run;
    expect(installer.installed, ['/updates/caspian-owner-12.apk']);
    // Cancelling Android's prompt leaves «نصب» to open it again.
    expect(state().downloading, isFalse);
    expect(state().readyApk, '/updates/caspian-owner-12.apk');
    await controller().downloadAndInstall();
    expect(installer.installed, hasLength(2));
    expect(downloader.downloads, 1);
  });

  test('the owner left the app: a notification, then the installer as soon '
      'as the app is back', () async {
    await controller().check();
    final run = controller().downloadAndInstall();
    await pumpEventQueue();
    controller().setForeground(visible: false);
    downloader.finish();
    await run;
    expect(installer.installed, isEmpty);
    expect(notifier.shown, [('1.2.0', true)]);

    controller().setForeground(visible: true);
    await pumpEventQueue();
    expect(installer.installed, ['/updates/caspian-owner-12.apk']);
  });

  test('without the install permission it explains, then continues when the '
      'owner comes back with it', () async {
    installer.allowed = false;
    await controller().check();
    await controller().downloadAndInstall();
    expect(state().problem, UpdateProblem.needsPermission);
    expect(downloader.downloads, 0);

    await controller().openInstallPermission();
    controller().setForeground(visible: false);
    installer.allowed = true;
    controller().setForeground(visible: true);
    await pumpEventQueue();
    expect(downloader.downloads, 1);
    expect(state().downloading, isTrue);
  });

  test('a failed download says so and can be retried', () async {
    await controller().check();
    final run = controller().downloadAndInstall();
    await pumpEventQueue();
    downloader.fail();
    await run;
    expect(state().problem, UpdateProblem.downloadFailed);
    expect(state().downloading, isFalse);
  });

  test('«رد کردن» keeps the update and notifies once per version', () async {
    await controller().check();
    await controller().dismiss();
    expect(state().dismissed, isTrue);
    expect(container.read(availableUpdateProvider), isNotNull);
    expect(notifier.shown, [('1.2.0', false)]);

    await controller().dismiss();
    expect(notifier.shown, hasLength(1));
  });

  test('the dialog is offered once per run', () async {
    await controller().check();
    final manifest = state().manifest!;
    expect(controller().markOffered(manifest), isTrue);
    expect(controller().markOffered(manifest), isFalse);
  });
}
