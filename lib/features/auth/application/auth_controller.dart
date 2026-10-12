import 'dart:convert';

import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/security/secure_store.dart';
import 'package:caspian_owner/features/auth/domain/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Why the owner was signed out, if it wasn't their choice.
enum SignOutReason { tooManyPinAttempts }

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

/// Login with phone + SMS code, and logout.
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    final session = ref.read(initialSessionProvider);
    return session == null ? const SignedOut() : SignedIn(session);
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);
  SecureStore get _store => ref.read(secureStoreProvider);

  /// Sends the SMS code. Throws `ApiException` on failure.
  Future<OtpRequest> requestCode(String phone) {
    final info = ref.read(appInfoProvider);
    return _repository.registerDevice(
      phone: phone,
      deviceId: info.deviceId,
      deviceModel: info.deviceModel,
      appVersion: info.fullVersion,
    );
  }

  /// Checks the code and keeps the session. Throws `ApiException`.
  Future<void> verify({required String phone, required String code}) async {
    final session = await _repository.verify(
      phone: phone,
      deviceId: ref.read(appInfoProvider).deviceId,
      code: code,
    );
    await _store.write(SecureKeys.session, jsonEncode(session.toJson()));
    state = SignedIn(session);
  }

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
