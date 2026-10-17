import 'package:caspian_owner/core/domain/app_config.dart';
import 'package:caspian_owner/core/domain/person.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Localized text, read from the widget tree's localizations.
typedef LocalizedText = String Function(BuildContext context);

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

  final LocalizedText label;
  final IconData icon;
  final String path;
  final bool adminOnly;
  final String? requiredFlag;

  /// Shown with a «به‌زودی» badge (a placeholder for a later feature).
  final bool comingSoon;
}

/// One bottom tab of a module: its first screen and the pages under it.
class ModuleTab {
  const new({
    required this.label,
    required this.icon,
    required this.path,
    required this.builder,
    this.routes = const [],
  });

  final LocalizedText label;
  final IconData icon;
  final String path;
  final WidgetBuilder builder;

  /// Pages opened from this tab (attach them to the root navigator to cover
  /// the tabs, like a request's detail).
  final List<RouteBase> routes;
}

/// One part of Caspian on the hub: the warehouse today; parking, CRM and
/// services later. The owner app only gets **partial** access to each
/// Caspian app (approvals, overviews, chat), never the full app.
///
/// Which modules are active comes from the server (`AppConfig.modules`,
/// `AppConfig.upcomingModules`). A new module is a new [AppModule] in the
/// registry (`moduleRegistryProvider`); the hub and router need no change.
abstract class AppModule {
  const new();

  /// Matches an entry in `AppConfig.modules`.
  String get id;

  LocalizedText get title;

  /// One line under the title on the hub tile.
  LocalizedText get subtitle;

  IconData get icon;

  /// The module's bottom tabs (at most 4). Empty: not built yet.
  List<ModuleTab> get tabs => const [];

  /// A number for the hub tile (e.g. pending requests); null for none.
  int? badge(WidgetRef ref) => null;

  List<MoreEntry> get moreEntries => const [];
}

/// A module that is announced but not built yet: a hub tile with
/// «به‌زودی» that opens a placeholder page.
class ComingSoonModule extends AppModule {
  const new({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  final String id;
  @override
  final LocalizedText title;
  @override
  final LocalizedText subtitle;
  @override
  final IconData icon;
}

enum ModuleAvailability { active, comingSoon }

/// The modules compiled into the app; the server decides which are active.
class ModuleRegistry {
  const new(this.modules);

  final List<AppModule> modules;

  AppModule? byId(String id) => modules.where((m) => m.id == id).firstOrNull;

  /// Active modules that have screens.
  List<AppModule> enabled(AppConfig config) => [
    for (final m in modules)
      if (config.modules.contains(m.id) && m.tabs.isNotEmpty) m,
  ];

  /// What the hub shows, in registry order: active modules, then announced
  /// ones as «به‌زودی». Anything else is hidden.
  List<(AppModule, ModuleAvailability)> hubTiles(AppConfig config) => [
    for (final m in modules)
      if (config.modules.contains(m.id) && m.tabs.isNotEmpty)
        (m, ModuleAvailability.active)
      else if (config.upcomingModules.contains(m.id) ||
          config.modules.contains(m.id))
        (m, ModuleAvailability.comingSoon),
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
