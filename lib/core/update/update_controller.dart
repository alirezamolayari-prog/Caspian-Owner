import 'dart:io';

import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/update/apk_downloader.dart';
import 'package:caspian_owner/core/update/apk_installer.dart';
import 'package:caspian_owner/core/update/update_checker.dart';
import 'package:caspian_owner/core/update/update_manifest.dart';
import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

enum UpdateProblem { downloadFailed, checksumFailed, needsPermission }

class UpdateState {
  const new({
    this.decision = const NoUpdate(),
    this.progress,
    this.problem,
    this.dismissed = false,
  });

  final UpdateDecision decision;

  /// 0..1 while downloading.
  final double? progress;
  final UpdateProblem? problem;

  /// «بعداً» was chosen for this optional update (this session).
  final bool dismissed;

  bool get required => decision is RequiredUpdate;

  UpdateManifest? get manifest => switch (decision) {
    OptionalUpdate(:final manifest) ||
    RequiredUpdate(:final manifest) => manifest,
    NoUpdate() => null,
  };
}

final updateCheckerProvider = Provider<UpdateChecker>((ref) => UpdateChecker());

final apkInstallerProvider = Provider<ApkInstaller>(
  (ref) => const ApkInstaller(),
);

/// Where update APKs go (the FileProvider shares `cache/updates/`).
final updateDirectoryProvider = FutureProvider<Directory>(
  (ref) async => Directory('${(await getTemporaryDirectory()).path}/updates'),
);

final updateControllerProvider =
    NotifierProvider<UpdateController, UpdateState>(UpdateController.new);

/// Checks for updates on launch (at most once a day) and from About,
/// downloads with progress, verifies, and starts the installer.
class UpdateController extends Notifier<UpdateState> {
  static const checkedAtKey = 'update_checked_at';
  static const interval = Duration(days: 1);

  @override
  UpdateState build() => const UpdateState();

  /// Returns the manifest that was found, or null (nothing or no answer).
  Future<UpdateManifest?> check({bool force = false}) async {
    final store = ref.read(secureStoreProvider);
    if (!force) {
      final last = await store.read(checkedAtKey);
      if (last != null &&
          clock.now().difference(DateTime.parse(last)) < interval) {
        return null;
      }
    }
    final manifest = await ref.read(updateCheckerProvider).fetch();
    if (manifest != null) {
      await store.write(checkedAtKey, clock.now().toUtc().toIso8601String());
    }
    state = UpdateState(
      decision: decideUpdate(
        currentBuild: ref.read(appInfoProvider).buildNumber,
        manifest: manifest,
      ),
    );
    return manifest;
  }

  void later() =>
      state = UpdateState(decision: state.decision, dismissed: true);

  /// Asks for the install permission if needed, downloads, verifies and
  /// opens the system installer.
  Future<void> downloadAndInstall() async {
    final manifest = state.manifest;
    if (manifest == null) return;
    final installer = ref.read(apkInstallerProvider);
    if (!await installer.canInstall()) {
      state = UpdateState(
        decision: state.decision,
        problem: UpdateProblem.needsPermission,
      );
      return;
    }

    state = UpdateState(decision: state.decision, progress: 0);
    final downloader = ApkDownloader(
      directory: await ref.read(updateDirectoryProvider.future),
    );
    try {
      final apk = await downloader.download(
        manifest,
        onProgress: (received, total) => state = UpdateState(
          decision: state.decision,
          progress: total > 0 ? received / total : null,
        ),
      );
      state = UpdateState(decision: state.decision, progress: 1);
      await installer.install(apk.path);
    } on ApkChecksumException {
      state = UpdateState(
        decision: state.decision,
        problem: UpdateProblem.checksumFailed,
      );
    } on Object {
      state = UpdateState(
        decision: state.decision,
        problem: UpdateProblem.downloadFailed,
      );
    }
  }

  Future<void> openInstallPermission() =>
      ref.read(apkInstallerProvider).openInstallPermission();
}
