import 'dart:convert';

import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/features/auth/domain/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Why the owner was signed out, if it wasn't their choice.
enum SignOutReason {
  tooManyPinAttempts,

  /// The server answered `401`: the token expired (7 days) or the server
  /// changed.
  sessionExpired,
}

sealed class AuthState {
  const new();
}

final class SignedOut extends AuthState {
  const new([this.reason]);

  final SignOutReason? reason;
}

final class SignedIn extends AuthState {
  const new(this.session);

  final AuthSession session;
}

/// The session restored from secure storage at startup (bootstrap).
final initialSessionProvider = Provider<AuthSession?>((ref) => null);

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// Login with username + password, and logout.
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    final session = ref.read(initialSessionProvider);
    return session == null ? const SignedOut() : SignedIn(session);
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);
  SecureStore get _store => ref.read(secureStoreProvider);

  /// Logs in and keeps the session (token) in secure storage.
  /// Throws `ApiException` (wrong password: `UnauthorizedException`).
  Future<void> login({
    required String username,
    required String password,
  }) async {
    final session = await _repository.login(
      username: username,
      password: password,
    );
    await _store.write(SecureKeys.session, jsonEncode(session.toJson()));
    state = SignedIn(session);
  }

  /// The server refused our token (`401`): sign out once and show the
  /// login screen with «دوباره وارد شوید».
  Future<void> sessionExpired() async {
    // Several requests can fail with 401 at once; sign out only once.
    if (state is! SignedIn || _expiring) return;
    _expiring = true;
    try {
      await signOut(SignOutReason.sessionExpired);
    } finally {
      _expiring = false;
    }
  }

  bool _expiring = false;

  /// Logs out and wipes local data. The device id is kept.
  Future<void> signOut([SignOutReason? reason]) async {
    await ref.read(appDatabaseProvider).wipe();
    for (final key in [
      SecureKeys.session,
      SecureKeys.pinHash,
      SecureKeys.pinSalt,
    ]) {
      await _store.delete(key);
    }
    state = SignedOut(reason);
  }

  /// Reads a stored session (bootstrap), or null.
  static Future<AuthSession?> restore(SecureStore store) async {
    final raw = await store.read(SecureKeys.session);
    if (raw == null) return null;
    try {
      return AuthSession.fromJson(jsonDecode(raw) as Map<String, Object?>);
    } on Object {
      await store.delete(SecureKeys.session);
      return null;
    }
  }
}
