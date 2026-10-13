import 'dart:async';

import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/notifications/notification_providers.dart';
import 'package:caspian_owner/core/router/app_router.dart';
import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/core/theme/app_theme.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/requests/application/decision_controller.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root widget. Persian only, right-to-left, theme follows the system.
class CaspianOwnerApp extends ConsumerStatefulWidget {
  const new({this.themeMode, super.key});

  /// Forces a theme (tests); otherwise the owner's setting is used.
  final ThemeMode? themeMode;

  static const locale = Locale('fa');

  @override
  ConsumerState<CaspianOwnerApp> createState() => _CaspianOwnerAppState();
}

class _CaspianOwnerAppState extends ConsumerState<CaspianOwnerApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Relock after 5 minutes in the background, and re-send decisions that
    // were queued while offline.
    _lifecycle = AppLifecycleListener(
      onHide: () =>
          ref.read(appLockControllerProvider.notifier).onBackgrounded(),
      onShow: () {
        ref.read(appLockControllerProvider.notifier).onForegrounded();
        if (ref.read(authControllerProvider) is SignedIn) {
          unawaited(ref.read(decisionControllerProvider.notifier).flush());
        }
      },
    );

    // Notification taps open their screen (through the lock if locked).
    _taps = ref
        .read(notificationTapsProvider)
        .stream
        .listen((target) => ref.read(routerProvider).go(target));
    final launchTarget = ref.read(launchNotificationTargetProvider);
    if (launchTarget != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(routerProvider).go(launchTarget),
      );
    }

    // Background check runs only while signed in with notifications on.
    ref.listenManual(
      _notificationsWanted,
      (previous, wanted) => _schedule(wanted: wanted, first: previous == null),
      fireImmediately: true,
    );
  }

  late final StreamSubscription<String> _taps;

  static final _notificationsWanted = Provider<bool>(
    (ref) =>
        ref.watch(authControllerProvider) is SignedIn &&
        ref.watch(settingsControllerProvider.select((s) => s.notifications)),
  );

  void _schedule({required bool wanted, required bool first}) {
    final scheduler = ref.read(notificationSchedulerProvider);
    if (wanted) {
      unawaited(scheduler.start());
      if (!first) unawaited(scheduler.askPermission());
    } else {
      unawaited(scheduler.stop());
    }
  }

  @override
  void dispose() {
    unawaited(_taps.cancel());
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode:
          widget.themeMode ??
          ref.watch(settingsControllerProvider.select((s) => s.themeMode)),
      locale: CaspianOwnerApp.locale,
      supportedLocales: const [CaspianOwnerApp.locale],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
