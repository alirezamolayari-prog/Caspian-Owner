import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/features/auth/data/api_account_repository.dart';
import 'package:caspian_owner/features/auth/domain/account_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_server.dart';

void main() {
  late FakeServer server;
  late ApiAccountRepository repository;

  setUp(() {
    server = FakeServer();
    repository = ApiAccountRepository(server.client());
  });

  test('request a code: JSON body, wait times from the answer', () async {
    server.on(
      'POST',
      '/auth/otp/request',
      FakeServer.json({'expires_in': 120, 'resend_after': 90}),
    );

    final sent = await repository.requestCode(
      mobile: '09123456789',
      purpose: OtpPurpose.resetPassword,
    );

    expect(sent.expiresIn, const Duration(seconds: 120));
    expect(sent.resendAfter, const Duration(seconds: 90));
    expect(server.requests.single.data, {
      'mobile': '09123456789',
      'purpose': 'reset_password',
    });
  });

  test('cooldown: code, message and Retry-After reach the screen', () async {
    server.on(
      'POST',
      '/auth/otp/request',
      FakeServer.fail(429, 'otp_cooldown', detail: 'صبر کنید', retryAfter: 61),
    );
    await expectLater(
      repository.requestCode(
        mobile: '09123456789',
        purpose: OtpPurpose.register,
      ),
      throwsA(
        isA<ServerException>()
            .having((e) => e.code, 'code', 'otp_cooldown')
            .having((e) => e.retryAfter, 'wait', const Duration(seconds: 61)),
      ),
    );
  });

  test('verify returns the verified token', () async {
    server.on(
      'POST',
      '/auth/otp/verify',
      FakeServer.json({'verified_token': 'vt', 'expires_in': 300}),
    );
    final token = await repository.verifyCode(
      mobile: '09123456789',
      code: '482913',
      purpose: OtpPurpose.register,
    );
    expect(token, 'vt');
    expect(server.requests.single.data, {
      'mobile': '09123456789',
      'code': '482913',
      'purpose': 'register',
    });
  });

  test('a wrong code keeps the server message (tries left)', () async {
    server.on(
      'POST',
      '/auth/otp/verify',
      FakeServer.fail(400, 'code_wrong', detail: '۳ بار دیگر'),
    );
    await expectLater(
      repository.verifyCode(
        mobile: '09123456789',
        code: '000000',
        purpose: OtpPurpose.register,
      ),
      throwsA(
        isA<ServerException>()
            .having((e) => e.code, 'code', 'code_wrong')
            .having((e) => e.messageFa, 'detail', '۳ بار دیگر'),
      ),
    );
  });

  test('register sends names and password with the token', () async {
    server.on(
      'POST',
      '/auth/otp/register',
      FakeServer.json({'status': 'pending'}, status: 201),
    );
    await repository.register(
      verifiedToken: 'vt',
      firstName: 'مهدی',
      lastName: 'کریمی',
      password: 'my-own-strong-pass',
    );
    expect(server.requests.single.data, {
      'verified_token': 'vt',
      'first_name': 'مهدی',
      'last_name': 'کریمی',
      'password': 'my-own-strong-pass',
    });
  });

  test('reset password sends the new password with the token', () async {
    server.on(
      'POST',
      '/auth/otp/reset-password',
      FakeServer.json({'status': 'ok'}),
    );
    await repository.resetPassword(verifiedToken: 'vt', newPassword: 'p');
    expect(server.requests.single.data, {
      'verified_token': 'vt',
      'new_password': 'p',
    });
  });

  test('change password uses the login token', () async {
    server.on('POST', '/auth/change-password', FakeServer.json({}));
    await repository.changePassword(
      accessToken: 'first',
      currentPassword: 'old',
      newPassword: 'new-strong-pass',
    );
    final request = server.requests.single;
    expect(request.headers['Authorization'], 'Bearer first');
    expect(request.data, {
      'current_password': 'old',
      'new_password': 'new-strong-pass',
    });
  });
}
