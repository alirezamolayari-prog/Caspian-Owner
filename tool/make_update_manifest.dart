// Writes update.json (the update manifest, contract: `UpdateManifest`).
//
//   dart run tool/make_update_manifest.dart \
//     --apk build/app/outputs/flutter-apk/caspian-owner-1.2.0.apk \
//     --url https://github.com/<owner>/<repo>/releases/download/v1.2.0/caspian-owner-1.2.0.apk \
//     --changelog docs/CHANGELOG.md --out update.json
//
// Version and build come from pubspec.yaml; the minimum supported build
// from tool/min_supported_build.txt; the Persian notes from the matching
// "## X.Y.Z" section of the changelog.
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:crypto/crypto.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('apk', mandatory: true)
    ..addOption('url', mandatory: true)
    ..addOption('pubspec', defaultsTo: 'pubspec.yaml')
    ..addOption('min-build-file', defaultsTo: 'tool/min_supported_build.txt')
    ..addOption('changelog', defaultsTo: 'docs/CHANGELOG.md')
    ..addOption('out', defaultsTo: 'update.json');
  final args = parser.parse(arguments);

  final apk = File(args.option('apk')!);
  final (version, build) = readVersion(
    File(args.option('pubspec')!).readAsStringSync(),
  );
  final minFile = File(args.option('min-build-file')!);
  final minBuild = minFile.existsSync()
      ? int.parse(minFile.readAsStringSync().trim())
      : 1;

  final manifest = buildManifest(
    version: version,
    build: build,
    minSupportedBuild: minBuild,
    apkUrl: args.option('url')!,
    sha256Hex: (await sha256.bind(apk.openRead()).first).toString(),
    sizeBytes: apk.lengthSync(),
    changelogFa: changelogSection(
      File(args.option('changelog')!).readAsStringSync(),
      version,
    ),
    publishedAt: DateTime.now().toUtc(),
  );
  File(args.option('out')!)
      .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(manifest));
  stdout.writeln('update.json: $version+$build, ${manifest['size_bytes']} B');
}

/// `version: 1.2.0+12` → ('1.2.0', 12).
(String, int) readVersion(String pubspec) {
  final m = RegExp(
    r'^version:\s*(\d+\.\d+\.\d+)\+(\d+)\s*$',
    multiLine: true,
  ).firstMatch(pubspec);
  if (m == null) throw const FormatException('No version in pubspec.yaml');
  return (m.group(1)!, int.parse(m.group(2)!));
}

/// The body of the `## X.Y.Z` section, without its heading.
String changelogSection(String changelog, String version) {
  final lines = const LineSplitter().convert(changelog);
  final start = lines.indexWhere((l) => l.startsWith('## $version'));
  if (start < 0) return '';
  final end = lines.indexWhere((l) => l.startsWith('## '), start + 1);
  return lines
      .sublist(start + 1, end < 0 ? lines.length : end)
      .join('\n')
      .trim();
}

Map<String, Object> buildManifest({
  required String version,
  required int build,
  required int minSupportedBuild,
  required String apkUrl,
  required String sha256Hex,
  required int sizeBytes,
  required String changelogFa,
  required DateTime publishedAt,
}) {
  if (minSupportedBuild > build) {
    throw ArgumentError(
      'min_supported_build ($minSupportedBuild) is above build ($build).',
    );
  }
  return {
    'version': version,
    'build': build,
    'min_supported_build': minSupportedBuild,
    'apk_url': apkUrl,
    'sha256': sha256Hex,
    'size_bytes': sizeBytes,
    'changelog_fa': changelogFa,
    'published_at': publishedAt.toIso8601String(),
  };
}
