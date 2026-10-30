import 'package:caspian_owner/core/modules/module_providers.dart';
import 'package:caspian_owner/core/router/app_shell.dart';
import 'package:caspian_owner/core/router/navigator_keys.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/core/update/update_controller.dart';
import 'package:caspian_owner/core/update/update_screen.dart';
import 'package:caspian_owner/core/widgets/server_feature_gate.dart';
import 'package:caspian_owner/features/auth/application/account_flow.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/auth/domain/account_repository.dart';
import 'package:caspian_owner/features/auth/presentation/account_status_screen.dart';
import 'package:caspian_owner/features/auth/presentation/forgot_password_screen.dart';
import 'package:caspian_owner/features/auth/presentation/lock_screen.dart';
import 'package:caspian_owner/features/auth/presentation/login_screen.dart';
import 'package:caspian_owner/features/auth/presentation/new_password_screen.dart';
import 'package:caspian_owner/features/auth/presentation/otp_screen.dart';
import 'package:caspian_owner/features/auth/presentation/pin_setup_screen.dart';
import 'package:caspian_owner/features/auth/presentation/register_screen.dart';
import 'package:caspian_owner/features/auth/presentation/unlock_offer_screen.dart';
import 'package:caspian_owner/features/hub/presentation/hub_screen.dart';
import 'package:caspian_owner/features/hub/presentation/module_placeholder_screen.dart';
import 'package:caspian_owner/features/more/presentation/about_screen.dart';
import 'package:caspian_owner/features/more/presentation/developer_screen.dart';
import 'package:caspian_owner/features/more/presentation/more_screen.dart';
import 'package:caspian_owner/features/more/presentation/purchase_list_screen.dart';
import 'package:caspian_owner/features/more/presentation/users_screen.dart';
import 'package:caspian_owner/features/notifications/presentation/notifications_screen.dart';
import 'package:caspian_owner/features/reports/presentation/reports_screen.dart';
import 'package:caspian_owner/features/settings/presentation/settings_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    navigatorKey: rootNavigatorKey,
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
        builder: (context, state) => const UpdateScreen(),
      ),
      // Optional updates are installed from «درباره و نسخه».
      GoRoute(path: Routes.update, redirect: (context, state) => Routes.about),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(path: Routes.otp, builder: (context, state) => const OtpScreen()),
      GoRoute(
        path: Routes.newPassword,
        builder: (context, state) => Consumer(
          builder: (context, ref, _) => NewPasswordScreen(
            mode:
                ref.read(accountFlowProvider)?.purpose ==
                    OtpPurpose.resetPassword
                ? NewPasswordMode.reset
                : NewPasswordMode.register,
          ),
        ),
      ),
      GoRoute(
        path: Routes.changePassword,
        builder: (context, state) =>
            const NewPasswordScreen(mode: NewPasswordMode.changeFirst),
      ),
      GoRoute(
        path: Routes.registered,
        builder: (context, state) =>
            const AccountStatusScreen(status: AccountStatus.registered),
      ),
      GoRoute(
        path: '/account/:status',
        builder: (context, state) => AccountStatusScreen(
          status: AccountStatus.parse(state.pathParameters['status']),
        ),
      ),
      GoRoute(
        path: Routes.unlockOffer,
        builder: (context, state) => const UnlockOfferScreen(),
      ),
      GoRoute(
        path: Routes.lock,
        builder: (context, state) => const LockScreen(),
      ),
      GoRoute(
        path: Routes.pinSetup,
        builder: (context, state) => const PinSetupScreen(),
      ),
      // Where the app opens: one tile per Caspian module.
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HubScreen(),
      ),
      GoRoute(
        path: '/m/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            ModulePlaceholderScreen(moduleId: state.pathParameters['id']!),
      ),
      // Each module with screens gets its own bottom tabs.
      for (final module in ref.read(moduleRegistryProvider).modules)
        if (module.tabs.isNotEmpty)
          StatefulShellRoute.indexedStack(
            builder: (context, state, shell) =>
                ModuleShell(module: module, shell: shell),
            branches: [
              for (final tab in module.tabs)
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: tab.path,
                      builder: (context, state) => tab.builder(context),
                      routes: tab.routes,
                    ),
                  ],
                ),
            ],
          ),
      GoRoute(
        path: Routes.more,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const MoreScreen(),
      ),
      for (final (path, screen) in <(String, Widget)>[
        // Shows the update row even while the list itself is «به‌زودی».
        (Routes.notifications, const NotificationsScreen()),
        // No server API for this yet: «به‌زودی» on Caspian Server v1.
        (
          Routes.reports,
          ServerFeatureGate(
            title: (l10n) => l10n.reportsTitle,
            child: const ReportsScreen(),
          ),
        ),
        (Routes.purchases, const PurchaseListScreen()),
        (Routes.users, const UsersScreen()),
        (Routes.settings, const SettingsScreen()),
        (Routes.about, const AboutScreen()),
        (Routes.developer, const DeveloperScreen()),
      ])
        GoRoute(
          path: path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => screen,
        ),
    ],
  );
  ref
    ..onDispose(router.dispose)
    ..onDispose(refresh.dispose);
  return router;
});
