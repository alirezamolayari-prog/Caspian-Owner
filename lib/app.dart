import 'dart:async';

import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
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
  }

  @override
  void dispose() {
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
