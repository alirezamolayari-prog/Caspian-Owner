import 'dart:async';

import 'package:caspian_owner/core/security/secure_screen.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureScreenProvider = Provider<SecureScreen>(
  (ref) => const SecureScreen(),
);

/// Wrap sensitive screens (requests, stock, counts) with this: screenshots
/// and the recent-apps preview are blocked while it is shown, unless the
/// owner turned that off in Settings.
class SecureScreenScope extends ConsumerStatefulWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SecureScreenScope> createState() => _SecureScreenScopeState();
}

class _SecureScreenScopeState extends ConsumerState<SecureScreenScope> {
  late final SecureScreen _screen = ref.read(secureScreenProvider);

  @override
  void initState() {
    super.initState();
    unawaited(
      _screen.set(secure: ref.read(settingsControllerProvider).secureScreens),
    );
  }

  @override
  void dispose() {
    unawaited(_screen.set(secure: false));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      settingsControllerProvider.select((s) => s.secureScreens),
      (_, secure) => unawaited(_screen.set(secure: secure)),
    );
    return widget.child;
  }
}
