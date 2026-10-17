import 'package:caspian_owner/core/domain/app_config.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/modules/app_module.dart';
import 'package:caspian_owner/core/router/navigator_keys.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/features/assistant/presentation/assistant_screen.dart';
import 'package:caspian_owner/features/home/application/home_controller.dart';
import 'package:caspian_owner/features/home/presentation/home_screen.dart';
import 'package:caspian_owner/features/requests/presentation/request_detail_screen.dart';
import 'package:caspian_owner/features/requests/presentation/requests_screen.dart';
import 'package:caspian_owner/features/stock/presentation/stock_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «انبار»: the owners' part of the Caspian Warehouse app (escalated
/// requests, stock, the assistant).
class WarehouseModule extends AppModule {
  const new();

  @override
  String get id => 'warehouse';

  @override
  LocalizedText get title =>
      (c) => AppLocalizations.of(c).moduleWarehouse;

  @override
  LocalizedText get subtitle =>
      (c) => AppLocalizations.of(c).moduleWarehouseSubtitle;

  @override
  IconData get icon => AppIcons.warehouse;

  /// Requests waiting for an owner.
  @override
  int? badge(WidgetRef ref) =>
      ref.watch(homeControllerProvider).value?.pendingCount;

  @override
  List<ModuleTab> get tabs => [
    ModuleTab(
      label: (c) => AppLocalizations.of(c).tabHome,
      icon: AppIcons.home,
      path: Routes.warehouse,
      builder: (_) => const HomeScreen(),
    ),
    ModuleTab(
      label: (c) => AppLocalizations.of(c).tabRequests,
      icon: AppIcons.requests,
      path: Routes.requests,
      builder: (_) => const RequestsScreen(),
      routes: [
        // Detail covers the bottom bar (UI spec 5.3).
        GoRoute(
          path: ':id',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) =>
              RequestDetailScreen(requestId: state.pathParameters['id']!),
        ),
      ],
    ),
    ModuleTab(
      label: (c) => AppLocalizations.of(c).tabStock,
      icon: AppIcons.stock,
      path: Routes.stock,
      builder: (_) => const StockScreen(),
    ),
    ModuleTab(
      label: (c) => AppLocalizations.of(c).tabAssistant,
      icon: AppIcons.assistant,
      path: Routes.assistant,
      builder: (_) => const AssistantScreen(),
    ),
  ];

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
