import 'package:caspian_owner/core/domain/app_config.dart';
import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/modules/app_module.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

String _label(BuildContext _) => '';

ModuleTab _tab(String path) => ModuleTab(
  label: _label,
  icon: const IconData(9),
  path: path,
  builder: (_) => const SizedBox(),
);

/// A module with screens.
class _Module extends AppModule {
  const new(this.id, this.paths, this.moreEntries);

  @override
  final String id;
  final List<String> paths;
  @override
  final List<MoreEntry> moreEntries;

  @override
  LocalizedText get title => _label;
  @override
  LocalizedText get subtitle => _label;
  @override
  IconData get icon => const IconData(1);
  @override
  List<ModuleTab> get tabs => [for (final p in paths) _tab(p)];
}

void main() {
  const warehouse = _Module(
    'warehouse',
    ['/warehouse', '/requests'],
    [
      MoreEntry(label: _label, icon: IconData(1), path: '/reports'),
      MoreEntry(
        label: _label,
        icon: IconData(2),
        path: '/users',
        adminOnly: true,
      ),
      MoreEntry(
        label: _label,
        icon: IconData(3),
        path: '/purchases',
        requiredFlag: FeatureFlags.purchaseList,
      ),
    ],
  );
  const parking = _Module(
    'parking',
    ['/parking'],
    [MoreEntry(label: _label, icon: IconData(4), path: '/parking-report')],
  );
  const crm = ComingSoonModule(
    id: 'crm',
    title: _label,
    subtitle: _label,
    icon: IconData(5),
  );
  const registry = ModuleRegistry([warehouse, parking, crm]);
  const config = AppConfig(
    featureFlags: [FeatureFlags.reports],
    modules: ['warehouse'],
    upcomingModules: ['crm'],
    minSupportedBuild: 1,
  );
  const admin = Owner(id: 'o-1', nameFa: 'علیرضا', isAdmin: true);
  const owner = Owner(id: 'o-2', nameFa: 'حسین کاظمی', isAdmin: false);

  List<String> paths(AppConfig c, Owner o) =>
      registry.moreEntriesFor(c, o).map((e) => e.path).toList();

  List<(String, ModuleAvailability)> tiles(AppConfig c) => [
    for (final (m, a) in registry.hubTiles(c)) (m.id, a),
  ];

  test('only modules enabled by the server are active', () {
    expect(registry.enabled(config).map((m) => m.id), ['warehouse']);
  });

  test('the hub shows active modules and announced ones as coming soon', () {
    expect(tiles(config), [
      ('warehouse', ModuleAvailability.active),
      ('crm', ModuleAvailability.comingSoon),
    ]);
    // Parking is compiled in, but the server doesn't mention it: hidden.
  });

  test('a module without screens is never active, even if enabled', () {
    final enabled = config.copyWith(modules: ['warehouse', 'crm']);
    expect(tiles(enabled), contains(('crm', ModuleAvailability.comingSoon)));
    expect(registry.enabled(enabled).map((m) => m.id), ['warehouse']);
  });

  test('admin-only entries are hidden from other owners', () {
    expect(paths(config, admin), ['/reports', '/users']);
    expect(paths(config, owner), ['/reports']);
  });

  test('entries behind a feature flag appear when the flag is on', () {
    final withFlag = config.copyWith(featureFlags: [FeatureFlags.purchaseList]);
    expect(paths(withFlag, owner), ['/reports', '/purchases']);
  });

  test('a new module plugs in by being enabled in config', () {
    final both = config.copyWith(modules: ['warehouse', 'parking']);
    expect(paths(both, owner), ['/reports', '/parking-report']);
    expect(tiles(both).first, ('warehouse', ModuleAvailability.active));
    expect(tiles(both)[1], ('parking', ModuleAvailability.active));
  });
}
