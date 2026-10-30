import 'dart:async';
import 'dart:io';

import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/notifications/notification_providers.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/update/apk_downloader.dart';
import 'package:caspian_owner/core/update/apk_installer.dart';
import 'package:caspian_owner/core/update/update_checker.dart';
import 'package:caspian_owner/core/update/update_manifest.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

enum UpdateProblem {
  downloadFailed,
  checksumFailed,
  needsPermission,
  installFailed,
}

class UpdateState {
  const new({
    this.decision = const NoUpdate(),
    this.downloading = false,
    this.progress,
    this.problem,
    this.readyApk,
    this.dismissed = false,
  });

  final UpdateDecision decision;

  /// The APK is being downloaded (the owner may leave the page meanwhile).
  final bool downloading;

  /// 0..1 while downloading; null when the size is unknown.
  final double? progress;
  final UpdateProblem? problem;

  /// A downloaded, verified APK waiting for Android's installer.
  final String? readyApk;

  /// «رد کردن» was chosen for this update (this run of the app).
  final bool dismissed;

  bool get required => decision is RequiredUpdate;

  UpdateManifest? get manifest => switch (decision) {
    OptionalUpdate(:final manifest) ||
    RequiredUpdate(:final manifest) => manifest,
    NoUpdate() => null,
  };
}

/// The optional update the owner can install (bell dot, «اعلان‌ها» row,
/// About panel), or null.
final availableUpdateProvider = Provider<UpdateManifest?>((ref) {
  final update = ref.watch(updateControllerProvider);
  return update.decision is OptionalUpdate ? update.manifest : null;
});

final updateCheckerProvider = Provider<UpdateChecker>((ref) => UpdateChecker());

final apkInstallerProvider = Provider<ApkInstaller>(
  (ref) => const ApkInstaller(),
);

/// Where update APKs go (the FileProvider shares `cache/updates/`).
final updateDirectoryProvider = FutureProvider<Directory>(
  (ref) async => Directory('${(await getTemporaryDirectory()).path}/updates'),
);

final apkDownloaderProvider = FutureProvider<ApkDownloader>(
  (ref) async =>
      ApkDownloader(directory: await ref.watch(updateDirectoryProvider.future)),
);

final updateControllerProvider =
    NotifierProvider<UpdateController, UpdateState>(UpdateController.new);

/// Checks for updates on every launch and from About, downloads with
/// progress, verifies, and starts the installer.
///
/// The download belongs to this controller, not to a screen: the owner can
/// leave About (or the app) and Android's install prompt still opens when
/// the file is ready (right away in the foreground, otherwise as soon as
/// the app is back, after a phone notification).
class UpdateController extends Notifier<UpdateState> {
  /// The last build announced with a phone notification (once per version).
  static const notifiedBuildKey = 'update_notified_build';

  /// Link opened by the update notifications: «درباره و نسخه».
  static const target = Routes.about;

  bool _foreground = true;
  int? _offeredBuild;
  bool _installWhenBack = false;
  bool _continueAfterPermission = false;

  @override
  UpdateState build() => const UpdateState();

  /// Returns the manifest that was found, or null (nothing or no answer).
  /// A failed check keeps what is already known.
  Future<UpdateManifest?> check() async {
    final manifest = await ref.read(updateCheckerProvider).fetch();
    if (manifest == null) return null;
    final decision = decideUpdate(
      currentBuild: ref.read(appInfoProvider).buildNumber,
      manifest: manifest,
    );
    if (decision is! NoUpdate && state.manifest?.build == manifest.build) {
      // Same version: keep a running download or a ready APK.
      state = _next(
        decision: decision,
        downloading: state.downloading,
        progress: state.progress,
        problem: state.problem,
        readyApk: state.readyApk,
      );
    } else {
      state = UpdateState(decision: decision);
    }
    return manifest;
  }

  /// True the first time [manifest] is offered in this run (the dialog is
  /// shown again on the next start while the update is pending).
  bool markOffered(UpdateManifest manifest) {
    if (_offeredBuild == manifest.build) return false;
    _offeredBuild = manifest.build;
    return true;
  }

  /// «رد کردن»: no dialog again in this run. The update stays on the bell
  /// and gets one phone notification per version.
  Future<void> dismiss() async {
    state = _next(
      downloading: state.downloading,
      progress: state.progress,
      problem: state.problem,
      readyApk: state.readyApk,
      dismissed: true,
    );
    final manifest = state.manifest;
    final notifier = ref.read(updateNotifierProvider);
    if (manifest == null || notifier == null) return;
    final store = ref.read(secureStoreProvider);
    if (await store.read(notifiedBuildKey) == '${manifest.build}') return;
    await store.write(notifiedBuildKey, '${manifest.build}');
    await notifier.showUpdate(
      version: manifest.version,
      ready: false,
      target: target,
    );
  }

  /// Asks for the install permission if needed, downloads, verifies and
  /// opens the system installer. A second tap while downloading does
  /// nothing.
  Future<void> downloadAndInstall() async {
    final manifest = state.manifest;
    if (manifest == null || state.downloading) return;
    if (state.readyApk case final apk?) return _install(apk);

    final installer = ref.read(apkInstallerProvider);
    if (!await installer.canInstall()) {
      state = _next(problem: UpdateProblem.needsPermission);
      return;
    }

    state = _next(downloading: true, progress: 0);
    try {
      final downloader = await ref.read(apkDownloaderProvider.future);
      final apk = await downloader.download(
        manifest,
        onProgress: (received, total) => state = _next(
          downloading: true,
          progress: total > 0 ? (received / total).clamp(0.0, 1.0) : null,
        ),
      );
      state = _next(readyApk: apk.path);
      if (_foreground) {
        await _install(apk.path);
      } else {
        _installWhenBack = true;
        await ref
            .read(updateNotifierProvider)
            ?.showUpdate(
              version: manifest.version,
              ready: true,
              target: target,
            );
      }
    } on ApkChecksumException {
      state = _next(problem: UpdateProblem.checksumFailed);
    } on Object {
      state = _next(problem: UpdateProblem.downloadFailed);
    }
  }

  Future<void> openInstallPermission() {
    _continueAfterPermission = true;
    return ref.read(apkInstallerProvider).openInstallPermission();
  }

  /// Called by the app when it goes to the background and comes back.
  void setForeground({required bool visible}) {
    _foreground = visible;
    if (!visible) return;
    if (_installWhenBack && state.readyApk != null) {
      unawaited(_install(state.readyApk!));
    } else if (_continueAfterPermission &&
        state.problem == UpdateProblem.needsPermission) {
      _continueAfterPermission = false;
      unawaited(_continueIfAllowed());
    }
  }

  Future<void> _continueIfAllowed() async {
    if (await ref.read(apkInstallerProvider).canInstall()) {
      await downloadAndInstall();
    }
  }

  Future<void> _install(String path) async {
    _installWhenBack = false;
    try {
      await ref.read(apkInstallerProvider).install(path);
      // The owner may cancel Android's prompt: «نصب» opens it again.
      state = _next(readyApk: path);
    } on Object {
      state = _next(readyApk: path, problem: UpdateProblem.installFailed);
    }
  }

  /// The current update with new transient values; [decision] and
  /// [dismissed] are kept unless given.
  UpdateState _next({
    UpdateDecision? decision,
    bool downloading = false,
    double? progress,
    UpdateProblem? problem,
    String? readyApk,
    bool? dismissed,
  }) => UpdateState(
    decision: decision ?? state.decision,
    downloading: downloading,
    progress: progress,
    problem: problem,
    readyApk: readyApk,
    dismissed: dismissed ?? state.dismissed,
  );
}
