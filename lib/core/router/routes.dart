import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';

/// Every screen's path. Notifications deep-link with these (e.g.
/// `/requests/r-124`), so they are part of the app's contract.
abstract final class Routes {
  static const login = '/login';
  static const update = '/update';
  static const updateRequired = '/update-required';
  static const lock = '/lock';
  static const pinSetup = '/pin-setup';

  /// The «کاسپین» hub: one tile per module.
  static const home = '/';

  /// A module that isn't built yet («به‌زودی»).
  static String module(String id) => '/m/$id';

  // The warehouse module's four tabs. Paths are unchanged since v0.1.0
  // (notifications link to them), except its Home, now under the hub.
  static const warehouse = '/warehouse';
  static const requests = '/requests';
  static const stock = '/stock';
  static const assistant = '/assistant';

  // Pushed screens (no bottom bar).
  static const more = '/more';
  static const notifications = '/notifications';
  static String request(String id) => '/requests/$id';
  static String requestChat(String id) => '/requests/$id/chat';
  static const reports = '/reports';
  static const purchases = '/purchases';
  static const users = '/users';
  static const settings = '/settings';
  static const about = '/about';
  static const developer = '/developer';
}

/// Where to send the owner instead of [location], or null to stay.
/// - signed out → login
/// - phone without a screen lock and no app PIN → create a PIN
/// - locked → lock screen, then back to where they were going
String? appRedirect({
  required AuthState auth,
  required LockState lock,
  required Uri location,
  bool updateRequired = false,
}) {
  final path = location.path;
  // A build below min_supported_build can't be used at all.
  if (updateRequired) {
    return path == Routes.updateRequired ? null : Routes.updateRequired;
  }
  if (path == Routes.updateRequired) return Routes.home;
  if (auth is SignedOut) return path == Routes.login ? null : Routes.login;

  if (lock.needsPinSetup) {
    return path == Routes.pinSetup ? null : Routes.pinSetup;
  }
  if (lock.locked) {
    if (path == Routes.lock) return null;
    final from = path == Routes.login || path == Routes.pinSetup
        ? Routes.home
        : location.toString();
    return Uri(path: Routes.lock, queryParameters: {'from': from}).toString();
  }
  if (path == Routes.lock) {
    return location.queryParameters['from'] ?? Routes.home;
  }
  if (path == Routes.login || path == Routes.pinSetup) return Routes.home;
  return null;
}
