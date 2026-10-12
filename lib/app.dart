import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Root widget. Persian only, right-to-left, theme follows the system.
/// Routing arrives in M4.
class CaspianOwnerApp extends StatelessWidget {
  const new({this.home, this.themeMode = ThemeMode.system, super.key});

  /// Screen to show; the router replaces this in M4.
  final Widget? home;

  final ThemeMode themeMode;

  static const locale = Locale('fa');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [locale],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: home ?? const Scaffold(body: SafeArea(child: SizedBox.expand())),
    );
  }
}
