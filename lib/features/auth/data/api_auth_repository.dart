import 'dart:convert';

import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/network/api_client.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/features/auth/domain/auth_repository.dart';
import 'package:clock/clock.dart';

/// Login against Caspian Server:
/// 1. `POST /auth/login` (form fields) → token and role;
/// 2. only `owner` and `admin` accounts may use this app;
/// 3. `GET /auth/me` with the new token → id and name.
class ApiAuthRepository implements AuthRepository {
  const new(this._client);

  final ApiClient _client;

  /// The server's token lifetime (7 days); used if the token can't be read.
  static const fallbackLifetime = Duration(days: 7);

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    final token = ApiClient.asMap(
      await _client.post(
        '/auth/login',
        form: {'username': username.trim(), 'password': password},
      ),
    );
    final role = token['role'];
    if (role != 'owner' && role != 'admin') {
      throw const ServerException(code: 'not_owner', statusCode: 403);
    }
    final accessToken = token['access_token']! as String;
    final me = ApiClient.asMap(
      await _client.get('/auth/me', bearer: accessToken),
    );
    return AuthSession(
      accessToken: accessToken,
      refreshToken: '',
      expiresAt: tokenExpiry(accessToken) ?? clock.now().add(fallbackLifetime),
      owner: _owner(me),
    );
  }

  @override
  Future<Owner> me() async =>
      _owner(ApiClient.asMap(await _client.get('/auth/me')));

  static Owner _owner(Map<String, Object?> json) => Owner(
    id: '${json['id']}',
    nameFa: json['full_name']! as String,
    isAdmin: json['role'] == 'admin',
  );

  /// Reads `exp` from the token's middle part (a JWT is three base64 parts:
  /// header.payload.signature). Only for showing/keeping the expiry; the
  /// server checks the signature.
  static DateTime? tokenExpiry(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final exp = payload is Map<String, Object?> ? payload['exp'] : null;
      return exp is int
          ? DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true)
          : null;
    } on FormatException {
      return null;
    }
  }
}
