import 'dart:async';

import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/notifications/notification_providers.dart';
import 'package:caspian_owner/core/router/app_router.dart';
import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/core/sync/live_sync.dart';
import 'package:caspian_owner/core/theme/app_theme.dart';
import 'package:caspian_owner/core/update/update_controller.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/widgets/error_message.dart';
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
      onHide: () {
        _visible = false;
        ref.read(appLockControllerProvider.notifier).onBackgrounded();
        // No live polling in the background (battery); workmanager's
        // 15-minute check still brings notifications.
        ref.read(liveSyncProvider.notifier).stop();
        ref
            .read(updateControllerProvider.notifier)
            .setForeground(visible: false);
      },
      onShow: () {
        _visible = true;
        ref.read(appLockControllerProvider.notifier).onForegrounded();
        if (ref.read(authControllerProvider) is SignedIn) {
          unawaited(ref.read(decisionControllerProvider.notifier).flush());
        }
        _syncLive(wanted: ref.read(_liveSyncWanted));
        // A downloaded update opens Android's installer now; after the
        // «install unknown apps» permission the download continues.
        ref
            .read(updateControllerProvider.notifier)
            .setForeground(visible: true);
      },
    );

    // Once signed in: clean up stuck decisions, then send the queue.
    ref.listenManual(
      authControllerProvider.select((auth) => auth is SignedIn),
      (_, signedIn) {
        if (signedIn) {
          unawaited(ref.read(decisionControllerProvider.notifier).start());
        }
      },
      fireImmediately: true,
    );

    // A decision the server refused for good: say so (it is decidable again).
    ref.listenManual(decisionFailureProvider, (_, failure) {
      if (failure == null) return;
      final l10n = lookupAppLocalizations(CaspianOwnerApp.locale);
      _messenger.currentState
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              l10n.decisionFailed(
                toPersianDigits(failure.requestId),
                errorMessage(failure.error, l10n),
              ),
            ),
            duration: const Duration(seconds: 8),
          ),
        );
    });

    // Live updates from the server while visible and signed in.
    ref.listenManual(
      _liveSyncWanted,
      (_, wanted) => _syncLive(wanted: wanted),
      fireImmediately: true,
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

    // Update check on every launch; the dialog (once per run while the
    // update is pending) comes from UpdateOfferHost.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => unawaited(ref.read(updateControllerProvider.notifier).check()),
    );
    // The offer is hosted by the hub and the module shells, so it never
    // appears over the lock or login screen.

    // Background check runs only while signed in with notifications on.
    ref.listenManual(
      _notificationsWanted,
      (_, wanted) => _schedule(wanted: wanted),
      fireImmediately: true,
    );
  }

  late final StreamSubscription<String> _taps;

  final _messenger = GlobalKey<ScaffoldMessengerState>();

  static final _notificationsWanted = Provider<bool>(
    (ref) =>
        ref.watch(authControllerProvider) is SignedIn &&
        ref.watch(settingsControllerProvider.select((s) => s.notifications)),
  );

  bool _visible = true;

  static final _liveSyncWanted = Provider<bool>(
    (ref) =>
        ref.watch(authControllerProvider) is SignedIn &&
        ref.watch(dataSourceProvider) == DataSource.api,
  );

  void _syncLive({required bool wanted}) {
    final live = ref.read(liveSyncProvider.notifier);
    if (wanted && _visible) {
      live.start();
    } else {
      // Signed out: forget `since`, the next login starts fresh.
      live.stop(reset: !wanted);
    }
  }

  void _schedule({required bool wanted}) {
    final scheduler = ref.read(notificationSchedulerProvider);
    if (wanted) {
      unawaited(scheduler.start());
      // On every launch, not only at login: the owner may have dismissed
      // it, or signed in with an older version that never asked. Android
      // shows nothing when it is already allowed.
      unawaited(scheduler.askPermission());
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
      scaffoldMessengerKey: _messenger,
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
