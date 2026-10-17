import 'dart:async';

import 'package:caspian_owner/core/security/secure_screen.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureScreenProvider = Provider<SecureScreen>(
  (ref) => const SecureScreen(),
);

/// One switch for the whole window (Android FLAG_SECURE is per window):
/// secure while at least one [SecureScreenScope] is visible **and** the
/// owner left «جلوگیری از عکس صفحه» on.
///
/// Scopes don't set the flag themselves: one scope turning it off would
/// unprotect another screen that is still shown (closing a request detail
/// over the requests list), and one hidden screen would protect an
/// unrelated one (Settings over the kept-alive Stock tab).
final secureScreenControllerProvider = Provider<SecureScreenController>((ref) {
  final controller = SecureScreenController(
    ref.watch(secureScreenProvider),
    enabled: ref.read(settingsControllerProvider).secureScreens,
  );
  ref.listen(
    settingsControllerProvider.select((s) => s.secureScreens),
    (_, on) => controller.enabled = on,
  );
  return controller;
});

class SecureScreenController {
  new(this._screen, {required this._enabled});

  final SecureScreen _screen;
  final Map<Object, bool> _scopes = {};
  bool _enabled;
  bool? _applied;

  /// The flag as last sent to Android (null before the first change).
  bool? get applied => _applied;

  bool get enabled => _enabled;
  set enabled(bool value) {
    _enabled = value;
    _apply();
  }

  /// Adds or updates a scope; [visible] is false while it is hidden (an
  /// inactive tab, or a page covered by another one).
  void update(Object scope, {required bool visible}) {
    _scopes[scope] = visible;
    _apply();
  }

  void remove(Object scope) {
    if (_scopes.remove(scope) != null) _apply();
  }

  void _apply() {
    final secure = _enabled && _scopes.values.any((visible) => visible);
    if (secure == _applied) return;
    _applied = secure;
    unawaited(_screen.set(secure: secure));
  }
}

/// Wrap sensitive screens (requests, stock) with this. It counts as shown
/// only while its tickers run: go_router turns them off in inactive tabs,
/// and the navigator turns them off in pages covered by another page.
class SecureScreenScope extends ConsumerStatefulWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SecureScreenScope> createState() => _SecureScreenScopeState();
}

class _SecureScreenScopeState extends ConsumerState<SecureScreenScope> {
  late final SecureScreenController _controller = ref.read(
    secureScreenControllerProvider,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.update(this, visible: TickerMode.valuesOf(context).enabled);
  }

  @override
  void dispose() {
    _controller.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
