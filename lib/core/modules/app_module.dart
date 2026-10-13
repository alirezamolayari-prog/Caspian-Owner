import 'package:caspian_owner/core/domain/app_config.dart';
import 'package:caspian_owner/core/domain/person.dart';
import 'package:flutter/widgets.dart';

/// A screen a module adds to the router.
class ModuleRoute {
  const new({required this.path, required this.builder});

  final String path;
  final WidgetBuilder builder;
}

/// An entry a module adds to the More page.
class MoreEntry {
  const new({
    required this.label,
    required this.icon,
    required this.path,
    this.adminOnly = false,
    this.requiredFlag,
    this.comingSoon = false,
  });

  /// Localized label, read from the widget tree's localizations.
  final String Function(BuildContext context) label;
  final IconData icon;
  final String path;
  final bool adminOnly;
  final String? requiredFlag;

  /// Shown with a «به‌زودی» badge (a placeholder for a later feature).
  final bool comingSoon;
}

/// A part of the app that can be switched on per owner by the server
/// (`AppConfig.modules`). Today: `warehouse`. Later Caspian apps (parking,
/// services, CRM) plug in the same way without changing the shell.
abstract class AppModule {
  const new();

  /// Matches an entry in `AppConfig.modules`.
  String get id;

  /// Cards shown on Home, in order.
  List<WidgetBuilder> get homeCards => const [];

  List<MoreEntry> get moreEntries => const [];

  List<ModuleRoute> get routes => const [];
}

/// The modules compiled into the app; the server decides which are active.
class ModuleRegistry {
  const new(this.modules);

  final List<AppModule> modules;

  List<AppModule> enabled(AppConfig config) => [
    for (final m in modules)
      if (config.modules.contains(m.id)) m,
  ];

  /// More entries visible to [owner]: admin-only entries for admins, and
  /// only entries whose feature flag is on.
  List<MoreEntry> moreEntriesFor(AppConfig config, Owner owner) => [
    for (final m in enabled(config))
      for (final e in m.moreEntries)
        if ((!e.adminOnly || owner.isAdmin) &&
            (e.requiredFlag == null || config.hasFlag(e.requiredFlag!)))
          e,
  ];
}
