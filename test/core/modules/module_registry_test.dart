import 'package:caspian_owner/core/domain/app_config.dart';
import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/modules/app_module.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

String _label(BuildContext _) => '';

class _Warehouse extends AppModule {
  const new();

  @override
  String get id => 'warehouse';

  @override
  List<MoreEntry> get moreEntries => const [
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
  ];
}

class _Parking extends AppModule {
  const new();

  @override
  String get id => 'parking';

  @override
  List<MoreEntry> get moreEntries => const [
    MoreEntry(label: _label, icon: IconData(4), path: '/parking'),
  ];
}

void main() {
  const registry = ModuleRegistry([_Warehouse(), _Parking()]);
  const config = AppConfig(
    featureFlags: [FeatureFlags.reports],
    modules: ['warehouse'],
    minSupportedBuild: 1,
  );
  const admin = Owner(id: 'o-1', nameFa: 'علیرضا', isAdmin: true);
  const owner = Owner(id: 'o-2', nameFa: 'حسین کاظمی', isAdmin: false);

  List<String> paths(AppConfig c, Owner o) =>
      registry.moreEntriesFor(c, o).map((e) => e.path).toList();

  test('only modules enabled by the server are active', () {
    expect(registry.enabled(config).map((m) => m.id), ['warehouse']);
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
    expect(paths(both, owner), ['/reports', '/parking']);
  });
}
