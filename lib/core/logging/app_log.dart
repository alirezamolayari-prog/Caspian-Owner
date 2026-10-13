import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

/// A small on-device log (no third-party crash service). Files rotate at
/// [maxBytes]; [keepFiles] files are kept. Release builds record warnings
/// and errors only. Exported from the developer screen.
class AppLog {
  new(
    this.directory, {
    this.maxBytes = 256 * 1024,
    this.keepFiles = 3,
    LogLevel? minLevel,
  }) : minLevel =
           minLevel ?? (kReleaseMode ? LogLevel.warning : LogLevel.debug);

  final Directory directory;
  final int maxBytes;
  final int keepFiles;
  final LogLevel minLevel;

  /// The most recent lines, newest last (shown on the developer screen).
  final List<String> recent = [];
  static const _recentLimit = 300;

  Future<void> _pending = Future.value();

  File _file(int index) => File('${directory.path}/app_$index.log');

  /// The log files, newest first.
  List<File> get files => [
    for (var i = 0; i < keepFiles; i++)
      if (_file(i).existsSync()) _file(i),
  ];

  void debug(String message) => _log(LogLevel.debug, message);
  void info(String message) => _log(LogLevel.info, message);
  void warning(String message) => _log(LogLevel.warning, message);
  void error(String message, [Object? error, StackTrace? stack]) => _log(
    LogLevel.error,
    [message, ?error?.toString(), ?stack?.toString()].join('\n'),
  );

  void _log(LogLevel level, String message) {
    if (level.index < minLevel.index) return;
    final line =
        '${clock.now().toIso8601String()} ${level.name.toUpperCase()} '
        '$message';
    recent.add(line);
    if (recent.length > _recentLimit) recent.removeAt(0);
    // Writes are chained so lines never interleave.
    _pending = _pending.then((_) => _write(line)).catchError((Object _) {});
  }

  Future<void> _write(String line) async {
    if (!directory.existsSync()) directory.createSync(recursive: true);
    final current = _file(0);
    if (current.existsSync() && current.lengthSync() > maxBytes) _rotate();
    await current.writeAsString('$line\n', mode: FileMode.append, flush: true);
  }

  void _rotate() {
    final oldest = _file(keepFiles - 1);
    if (oldest.existsSync()) oldest.deleteSync();
    for (var i = keepFiles - 2; i >= 0; i--) {
      final f = _file(i);
      if (f.existsSync()) f.renameSync(_file(i + 1).path);
    }
  }

  /// Waits until everything logged so far is on disk.
  Future<void> flush() => _pending;
}
