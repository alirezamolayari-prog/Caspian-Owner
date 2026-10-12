import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';

/// Every screen's path. Notifications deep-link with these (e.g.
/// `/requests/r-124`), so they are part of the app's contract.
abstract final class Routes {
  static const login = '/login';
  static const lock = '/lock';
  static const pinSetup = '/pin-setup';

  // The four tabs.
  static const home = '/';
  static const requests = '/requests';
  static const stock = '/stock';
  static const assistant = '/assistant';

  // Pushed screens (no bottom bar).
  static const more = '/more';
  static String request(String id) => '/requests/$id';
  static const reports = '/reports';
  static const purchases = '/purchases';
  static const users = '/users';
  static const settings = '/settings';
  static const about = '/about';
  static const developer = '/developer';
  static const counts = '/counts';
  static const countNew = '/counts/new';
  static String count(String id) => '/counts/$id';
}

/// Where to send the owner instead of [location], or null to stay.
/// - signed out → login
/// - phone without a screen lock and no app PIN → create a PIN
/// - locked → lock screen, then back to where they were going
String? appRedirect({
  required AuthState auth,
  required LockState lock,
  required Uri location,
}) {
  final path = location.path;
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
