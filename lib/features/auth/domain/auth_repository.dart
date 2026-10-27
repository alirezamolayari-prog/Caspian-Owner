import 'package:caspian_owner/core/domain/person.dart';

/// The token and the owner after a successful login.
class AuthSession {
  const new({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.owner,
  });

  factory fromJson(Map<String, Object?> json) => AuthSession(
    accessToken: json['access_token']! as String,
    refreshToken: json['refresh_token'] as String? ?? '',
    expiresAt: DateTime.parse(json['expires_at']! as String),
    owner: Owner.fromJson(json['owner']! as Map<String, Object?>),
  );

  final String accessToken;

  /// Empty with Caspian Server v1 (no refresh: log in again after 7 days).
  final String refreshToken;
  final DateTime expiresAt;
  final Owner owner;

  /// Kept on the device (secure storage) in this shape.
  Map<String, Object?> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'expires_at': expiresAt.toUtc().toIso8601String(),
    'owner': owner.toJson(),
  };
}

/// The password was right, but it is a first password from the admin that
/// must be replaced before anything else works (`must_change_password`).
/// [accessToken] may only call `/auth/change-password`.
final class MustChangePasswordException implements Exception {
  const new(this.accessToken);

  final String accessToken;

  @override
  String toString() => 'MustChangePasswordException()';
}

/// Mobile-or-username + password login (Caspian Server `POST /auth/login`).
abstract interface class AuthRepository {
  /// Throws `ServerException` with the server's code for a wrong password
  /// (`invalid_credentials`), too many tries (`login_rate_limited`) or an
  /// account that is `account_pending`, `account_rejected` or
  /// `account_disabled`; `ServerException(code: 'not_owner')` for accounts
  /// that aren't owners (e.g. the warehouse account); and
  /// [MustChangePasswordException]. The mock accepts any username with the
  /// password `11111` (`UnauthorizedException` otherwise).
  Future<AuthSession> login({
    required String username,
    required String password,
  });

  /// The logged-in owner.
  Future<Owner> me();
}
