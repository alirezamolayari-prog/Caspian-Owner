import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/features/auth/domain/auth_repository.dart';
import 'package:clock/clock.dart';

/// Mock login. The only accepted code is `11111`. This repository exists
/// only while the app runs on the in-app mock (no server, sample data), so
/// the code works in release builds too: without it, nobody could sign in
/// to a mock-only release. The server's auth never knows this code.
class MockAuthRepository implements AuthRepository {
  const new(this._backend);

  static const testCode = '11111';

  final MockBackend _backend;

  static final _phone = RegExp(r'^09\d{9}$');

  @override
  Future<OtpRequest> registerDevice({
    required String phone,
    required String deviceId,
    required String deviceModel,
    required String appVersion,
  }) => _backend.call(() {
    if (!_phone.hasMatch(toLatinDigits(phone))) {
      throw const ServerException(
        code: 'invalid_phone',
        statusCode: 400,
        messageFa: 'شماره موبایل باید ۱۱ رقم باشد و با ۰۹ شروع شود.',
      );
    }
    return const OtpRequest(codeLength: 5, resendAfter: Duration(seconds: 60));
  });

  @override
  Future<AuthSession> verify({
    required String phone,
    required String deviceId,
    required String code,
  }) => _backend.call(() {
    if (toLatinDigits(code) != testCode) {
      throw const ServerException(
        code: 'invalid_code',
        statusCode: 401,
        messageFa: 'کد واردشده درست نیست.',
      );
    }
    return _session();
  });

  @override
  Future<AuthSession> refresh(String refreshToken) => _backend.call(_session);

  @override
  Future<Owner> me() => _backend.call(() => _backend.me);

  AuthSession _session() => AuthSession(
    accessToken: 'mock-access-${_backend.nextId('t')}',
    refreshToken: 'mock-refresh-${_backend.nextId('t')}',
    expiresAt: clock.now().add(const Duration(hours: 12)),
    owner: _backend.me,
  );
}
