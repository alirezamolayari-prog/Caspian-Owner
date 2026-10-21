import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/features/auth/domain/auth_repository.dart';
import 'package:clock/clock.dart';

/// Mock login for tests and previews: any username, password `11111`.
/// Only used with the in-app mock (no server), so it can never open real
/// data.
class MockAuthRepository implements AuthRepository {
  const new(this._backend);

  static const testPassword = '11111';

  final MockBackend _backend;

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) => _backend.call(() {
    if (username.trim().isEmpty || toLatinDigits(password) != testPassword) {
      throw const UnauthorizedException();
    }
    return AuthSession(
      accessToken: 'mock-access-${_backend.nextId('t')}',
      refreshToken: '',
      expiresAt: clock.now().add(const Duration(hours: 12)),
      owner: _backend.me,
    );
  });

  @override
  Future<Owner> me() => _backend.call(() => _backend.me);
}
