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

/// Username + password login (Caspian Server `POST /auth/login`).
abstract interface class AuthRepository {
  /// Throws `UnauthorizedException` for a wrong username or password, and
  /// `ServerException(code: 'not_owner')` for accounts that aren't owners
  /// (e.g. the warehouse account). The mock accepts any username with the
  /// password `11111`.
  Future<AuthSession> login({
    required String username,
    required String password,
  });

  /// The logged-in owner.
  Future<Owner> me();
}
