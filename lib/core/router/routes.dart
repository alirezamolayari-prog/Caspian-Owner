import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';

/// Every screen's path. Notifications deep-link with these (e.g.
/// `/requests/r-124`), so they are part of the app's contract.
abstract final class Routes {
  static const login = '/login';

  // Signed out: register, forgotten password, account status.
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  /// The SMS code step of either flow.
  static const otp = '/otp';

  /// The password step of either flow.
  static const newPassword = '/new-password';

  /// «درخواست شما ثبت شد»: waiting for the admin.
  static const registered = '/registered';

  /// Login answered `account_pending`, `account_rejected` or
  /// `account_disabled` ([status] without the `account_` prefix).
  static String accountStatus(String status) => '/account/$status';

  /// The admin's first password must be replaced.
  static const changePassword = '/change-password';

  /// After a password login: «اثر انگشت فعال شود؟».
  static const unlockOffer = '/unlock-offer';

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

/// Pages for owners who are not logged in.
bool isSignedOutPath(String path) =>
    const {
      Routes.login,
      Routes.register,
      Routes.forgotPassword,
      Routes.otp,
      Routes.newPassword,
      Routes.registered,
      Routes.changePassword,
    }.contains(path) ||
    path.startsWith('/account/');

/// Where to send the owner instead of [location], or null to stay.
/// - signed out → login (or register / forgot password / account status)
/// - just logged in with the password → offer the fingerprint
/// - no fingerprint unlock and no app PIN → create a PIN
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
  if (auth is SignedOut) return isSignedOutPath(path) ? null : Routes.login;

  final setupPaths = {Routes.unlockOffer, Routes.pinSetup};
  if (lock.offerPending) {
    return path == Routes.unlockOffer ? null : Routes.unlockOffer;
  }
  if (lock.needsPinSetup) {
    return path == Routes.pinSetup ? null : Routes.pinSetup;
  }
  if (lock.locked) {
    if (path == Routes.lock) return null;
    final from = isSignedOutPath(path) || setupPaths.contains(path)
        ? Routes.home
        : location.toString();
    return Uri(path: Routes.lock, queryParameters: {'from': from}).toString();
  }
  if (path == Routes.lock) {
    return location.queryParameters['from'] ?? Routes.home;
  }
  if (isSignedOutPath(path) || setupPaths.contains(path)) return Routes.home;
  return null;
}
