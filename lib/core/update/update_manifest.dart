/// The update manifest (`update.json`, contract: `UpdateManifest`).
class UpdateManifest {
  const new({
    required this.version,
    required this.build,
    required this.minSupportedBuild,
    required this.apkUrl,
    required this.sha256,
    required this.sizeBytes,
    required this.changelogFa,
    required this.publishedAt,
  });

  /// Throws [FormatException] for a manifest that can't be trusted.
  factory fromJson(Map<String, Object?> json) {
    final sha = json['sha256'];
    final url = json['apk_url'];
    if (sha is! String || !RegExp(r'^[0-9a-f]{64}$').hasMatch(sha)) {
      throw const FormatException('Bad sha256 in update manifest');
    }
    if (url is! String || !url.startsWith('https://')) {
      throw const FormatException('Update APK must be served over HTTPS');
    }
    return UpdateManifest(
      version: json['version']! as String,
      build: (json['build']! as num).toInt(),
      minSupportedBuild: (json['min_supported_build']! as num).toInt(),
      apkUrl: url,
      sha256: sha,
      sizeBytes: (json['size_bytes']! as num).toInt(),
      changelogFa: json['changelog_fa'] as String? ?? '',
      publishedAt: DateTime.parse(json['published_at']! as String),
    );
  }

  final String version;
  final int build;
  final int minSupportedBuild;
  final String apkUrl;
  final String sha256;
  final int sizeBytes;
  final String changelogFa;
  final DateTime publishedAt;
}

/// What to do about an available update.
sealed class UpdateDecision {
  const new();
}

final class NoUpdate extends UpdateDecision {
  const new();
}

/// A newer build exists: «به‌روزرسانی» / «بعداً».
final class OptionalUpdate extends UpdateDecision {
  const new(this.manifest);

  final UpdateManifest manifest;
}

/// This build is too old to keep using: blocking update screen.
final class RequiredUpdate extends UpdateDecision {
  const new(this.manifest);

  final UpdateManifest manifest;
}

/// Compares the installed build with the manifest.
UpdateDecision decideUpdate({
  required int currentBuild,
  required UpdateManifest? manifest,
}) {
  if (manifest == null) return const NoUpdate();
  if (currentBuild < manifest.minSupportedBuild) {
    return RequiredUpdate(manifest);
  }
  if (manifest.build > currentBuild) return OptionalUpdate(manifest);
  return const NoUpdate();
}
