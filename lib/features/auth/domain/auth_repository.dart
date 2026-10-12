import 'package:caspian_owner/core/domain/person.dart';

/// Result of starting login: an SMS code was sent.
class OtpRequest {
  const new({required this.codeLength, required this.resendAfter});

  final int codeLength;
  final Duration resendAfter;
}

/// Tokens and the owner after a successful login (contract: `AuthTokens`).
class AuthSession {
  const new({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.owner,
  });

  factory fromJson(Map<String, Object?> json) => AuthSession(
    accessToken: json['access_token']! as String,
    refreshToken: json['refresh_token']! as String,
    expiresAt: DateTime.parse(json['expires_at']! as String),
    owner: Owner.fromJson(json['owner']! as Map<String, Object?>),
  );

  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final Owner owner;

  /// Contract shape (`AuthTokens`), also used to keep the session on device.
  Map<String, Object?> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'expires_at': expiresAt.toUtc().toIso8601String(),
    'owner': owner.toJson(),
  };
}

/// Phone + one-time code login (contract: `/v1/auth/...`).
abstract interface class AuthRepository {
  /// Registers this device and sends an SMS code to [phone] (`09…`).
  Future<OtpRequest> registerDevice({
    required String phone,
    required String deviceId,
    required String deviceModel,
    required String appVersion,
  });

  /// Checks the code. Throws `ServerException` with code `invalid_code`.
  /// The mock accepts `11111` in debug builds only.
  Future<AuthSession> verify({
    required String phone,
    required String deviceId,
    required String code,
  });

  Future<AuthSession> refresh(String refreshToken);

  /// The logged-in owner.
  Future<Owner> me();
}
