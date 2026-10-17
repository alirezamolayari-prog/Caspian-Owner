import 'package:caspian_owner/core/router/app_shell.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/core/update/update_controller.dart';
import 'package:caspian_owner/core/update/update_screen.dart';
import 'package:caspian_owner/features/assistant/presentation/assistant_screen.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/auth/presentation/lock_screen.dart';
import 'package:caspian_owner/features/auth/presentation/login_screen.dart';
import 'package:caspian_owner/features/auth/presentation/pin_setup_screen.dart';
import 'package:caspian_owner/features/count/presentation/count_detail_screen.dart';
import 'package:caspian_owner/features/count/presentation/count_history_screen.dart';
import 'package:caspian_owner/features/count/presentation/count_start_screen.dart';
import 'package:caspian_owner/features/home/presentation/home_screen.dart';
import 'package:caspian_owner/features/more/presentation/about_screen.dart';
import 'package:caspian_owner/features/more/presentation/developer_screen.dart';
import 'package:caspian_owner/features/more/presentation/more_screen.dart';
import 'package:caspian_owner/features/more/presentation/purchase_list_screen.dart';
import 'package:caspian_owner/features/more/presentation/users_screen.dart';
import 'package:caspian_owner/features/notifications/presentation/notifications_screen.dart';
import 'package:caspian_owner/features/reports/presentation/reports_screen.dart';
import 'package:caspian_owner/features/requests/presentation/request_detail_screen.dart';
import 'package:caspian_owner/features/requests/presentation/requests_screen.dart';
import 'package:caspian_owner/features/settings/presentation/settings_screen.dart';
import 'package:caspian_owner/features/stock/presentation/stock_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// For dialogs shown from outside the widget tree (update prompt).
GlobalKey<NavigatorState> get rootNavigatorKey => _rootKey;

/// Re-runs the router's redirect whenever login, lock or a required update
/// changes.
class _RouterRefresh extends ChangeNotifier {
  new(Ref ref) {
    ref
      ..listen(authControllerProvider, (_, _) => notifyListeners())
      ..listen(appLockControllerProvider, (_, _) => notifyListeners())
      ..listen(
        updateControllerProvider.select((u) => u.required),
        (_, _) => notifyListeners(),
      );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);
  final router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.home,
    refreshListenable: refresh,
    redirect: (context, state) => appRedirect(
      auth: ref.read(authControllerProvider),
      lock: ref.read(appLockControllerProvider),
      location: state.uri,
      updateRequired: ref.read(updateControllerProvider).required,
    ),
    routes: [
      GoRoute(
        path: Routes.updateRequired,
        builder: (context, state) => const UpdateScreen(blocking: true),
      ),
      GoRoute(
        path: Routes.update,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const UpdateScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.lock,
        builder: (context, state) => const LockScreen(),
      ),
      GoRoute(
        path: Routes.pinSetup,
        builder: (context, state) => const PinSetupScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.requests,
                builder: (context, state) => const RequestsScreen(),
                routes: [
                  // Detail covers the bottom bar (UI spec 5.3).
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) => RequestDetailScreen(
                      requestId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.stock,
                builder: (context, state) => const StockScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.assistant,
                builder: (context, state) => const AssistantScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.more,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const MoreScreen(),
      ),
      for (final (path, screen) in <(String, Widget)>[
        (Routes.notifications, const NotificationsScreen()),
        (Routes.reports, const ReportsScreen()),
        (Routes.purchases, const PurchaseListScreen()),
        (Routes.users, const UsersScreen()),
        (Routes.settings, const SettingsScreen()),
        (Routes.about, const AboutScreen()),
        (Routes.developer, const DeveloperScreen()),
      ])
        GoRoute(
          path: path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) => screen,
        ),
      GoRoute(
        path: Routes.counts,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const CountHistoryScreen(),
        routes: [
          // 'new' before ':id', so it isn't read as a count id.
          GoRoute(
            path: 'new',
            parentNavigatorKey: _rootKey,
            builder: (context, state) => const CountStartScreen(),
          ),
          GoRoute(
            path: ':id',
            parentNavigatorKey: _rootKey,
            builder: (context, state) =>
                CountDetailScreen(countId: state.pathParameters['id']!),
          ),
        ],
      ),
    ],
  );
  ref
    ..onDispose(router.dispose)
    ..onDispose(refresh.dispose);
  return router;
});
