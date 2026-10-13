import 'dart:io';

import 'package:caspian_owner/core/update/update_manifest.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

/// The downloaded file doesn't match the manifest; it was deleted.
class ApkChecksumException implements Exception {
  const new();
}

/// Downloads the update APK into [directory]: resumes a partial download,
/// retries on weak networks, verifies SHA-256 before anything is
/// installed, and removes older APKs.
class ApkDownloader {
  new({required this.directory, Dio? dio, this.retries = 3})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
            ),
          );

  final Directory directory;
  final Dio _dio;
  final int retries;

  File apkFile(UpdateManifest m) =>
      File('${directory.path}/caspian-owner-${m.build}.apk');

  File _partFile(UpdateManifest m) => File('${apkFile(m).path}.part');

  /// Returns the verified APK. [onProgress] gets bytes received so far and
  /// the expected total.
  Future<File> download(
    UpdateManifest manifest, {
    void Function(int received, int total)? onProgress,
  }) async {
    directory.createSync(recursive: true);
    final apk = apkFile(manifest);
    if (apk.existsSync() && await _matches(apk, manifest)) return apk;

    final part = _partFile(manifest);
    for (var attempt = 1; ; attempt++) {
      final start = part.existsSync() ? part.lengthSync() : 0;
      if (start > 0 && start >= manifest.sizeBytes) break;
      try {
        final response = await _dio.download(
          manifest.apkUrl,
          part.path,
          deleteOnError: false,
          fileAccessMode: start > 0
              ? FileAccessMode.append
              : FileAccessMode.write,
          options: Options(headers: {if (start > 0) 'range': 'bytes=$start-'}),
          onReceiveProgress: (received, _) =>
              onProgress?.call(start + received, manifest.sizeBytes),
        );
        if (start > 0 && response.statusCode != 206) {
          // The server ignored the range and sent the whole file again:
          // the appended copy is corrupt, start over.
          part.deleteSync();
          if (attempt >= retries) throw const ApkChecksumException();
          continue;
        }
        break;
      } on DioException {
        if (attempt >= retries) rethrow;
        await Future<void>.delayed(Duration(seconds: 2 * attempt));
      }
    }

    if (!await _matches(part, manifest)) {
      part.deleteSync();
      throw const ApkChecksumException();
    }
    if (apk.existsSync()) apk.deleteSync();
    part.renameSync(apk.path);
    cleanup(keep: apk);
    return apk;
  }

  /// Deletes every downloaded APK except [keep].
  void cleanup({File? keep}) {
    if (!directory.existsSync()) return;
    // Compare names, not paths: separators can differ between a listed
    // path and one built by hand.
    final keepName = keep?.uri.pathSegments.last;
    for (final f in directory.listSync().whereType<File>()) {
      final name = f.uri.pathSegments.last;
      final ours =
          name.startsWith('caspian-owner-') &&
          (name.endsWith('.apk') || name.endsWith('.apk.part'));
      if (ours && name != keepName) f.deleteSync();
    }
  }

  static Future<bool> _matches(File file, UpdateManifest m) async {
    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString() == m.sha256;
  }
}
