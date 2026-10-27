import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/features/auth/domain/account_repository.dart';

/// [AccountRepository] for tests and previews: every code is
/// [testCode]; errors use the server's codes and wording.
class MockAccountRepository implements AccountRepository {
  new(this._backend);

  static const testCode = '123456';

  final MockBackend _backend;
  final _tokens = <String, OtpPurpose>{};

  @override
  Future<OtpSent> requestCode({
    required String mobile,
    required OtpPurpose purpose,
  }) => _backend.call(
    () => const OtpSent(
      expiresIn: Duration(minutes: 2),
      resendAfter: Duration(seconds: 90),
    ),
  );

  @override
  Future<String> verifyCode({
    required String mobile,
    required String code,
    required OtpPurpose purpose,
  }) => _backend.call(() {
    if (toLatinDigits(code) != testCode) {
      throw const ServerException(
        code: 'code_wrong',
        messageFa: 'کد درست نیست. ۴ بار دیگر می‌توانید امتحان کنید.',
        statusCode: 400,
      );
    }
    final token = 'verified-${_backend.nextId('v')}';
    _tokens[token] = purpose;
    return token;
  });

  @override
  Future<void> register({
    required String verifiedToken,
    required String firstName,
    required String lastName,
    required String password,
  }) => _backend.call(() => _use(verifiedToken, OtpPurpose.register));

  @override
  Future<void> resetPassword({
    required String verifiedToken,
    required String newPassword,
  }) => _backend.call(() => _use(verifiedToken, OtpPurpose.resetPassword));

  @override
  Future<void> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  }) => _backend.call(() {});

  void _use(String token, OtpPurpose purpose) {
    if (_tokens.remove(token) != purpose) {
      throw const ServerException(
        code: 'verification_invalid',
        messageFa: 'مهلت تأیید تمام شده است. از اول شروع کنید.',
        statusCode: 401,
      );
    }
  }
}
