import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';

/// Golden test setup.
/// - CI goldens (text drawn as blocks, font-independent) run everywhere.
/// - Pixel-exact platform goldens run only on a developer PC, because font
///   rendering differs between Windows and the Linux CI runner.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final isCi = Platform.environment.containsKey('CI');
  await AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(enabled: !isCi),
    ),
    run: testMain,
  );
}
