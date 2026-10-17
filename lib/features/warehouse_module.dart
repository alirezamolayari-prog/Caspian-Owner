import 'package:caspian_owner/core/domain/app_config.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/modules/app_module.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';

/// The warehouse part of the app (requests, stock, assistant are its tabs).
/// Other Caspian apps (parking, services, CRM) will add modules like this.
class WarehouseModule extends AppModule {
  const new();

  @override
  String get id => 'warehouse';

  @override
  List<MoreEntry> get moreEntries => [
    MoreEntry(
      label: (c) => AppLocalizations.of(c).moreReports,
      icon: AppIcons.reports,
      path: Routes.reports,
      requiredFlag: FeatureFlags.reports,
    ),
    MoreEntry(
      label: (c) => AppLocalizations.of(c).morePurchaseList,
      icon: AppIcons.purchase,
      path: Routes.purchases,
      comingSoon: true,
    ),
    MoreEntry(
      label: (c) => AppLocalizations.of(c).moreUsers,
      icon: AppIcons.users,
      path: Routes.users,
      adminOnly: true,
    ),
  ];
}
