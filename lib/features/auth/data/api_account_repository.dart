import 'package:caspian_owner/core/network/api_client.dart';
import 'package:caspian_owner/features/auth/domain/account_repository.dart';

/// [AccountRepository] on Caspian Server (owner-auth-api.md).
class ApiAccountRepository implements AccountRepository {
  const new(this._client);

  final ApiClient _client;

  @override
  Future<OtpSent> requestCode({
    required String mobile,
    required OtpPurpose purpose,
  }) async {
    final json = ApiClient.asMap(
      await _client.post(
        '/auth/otp/request',
        json: {'mobile': mobile, 'purpose': purpose.wire},
      ),
    );
    return OtpSent(
      expiresIn: _seconds(json['expires_in'], fallback: 120),
      resendAfter: _seconds(json['resend_after'], fallback: 90),
    );
  }

  @override
  Future<String> verifyCode({
    required String mobile,
    required String code,
    required OtpPurpose purpose,
  }) async {
    final json = ApiClient.asMap(
      await _client.post(
        '/auth/otp/verify',
        json: {'mobile': mobile, 'code': code, 'purpose': purpose.wire},
      ),
    );
    return json['verified_token']! as String;
  }

  @override
  Future<void> register({
    required String verifiedToken,
    required String firstName,
    required String lastName,
    required String password,
  }) => _client.post(
    '/auth/otp/register',
    json: {
      'verified_token': verifiedToken,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
    },
  );

  @override
  Future<void> resetPassword({
    required String verifiedToken,
    required String newPassword,
  }) => _client.post(
    '/auth/otp/reset-password',
    json: {'verified_token': verifiedToken, 'new_password': newPassword},
  );

  @override
  Future<void> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  }) => _client.post(
    '/auth/change-password',
    bearer: accessToken,
    json: {'current_password': currentPassword, 'new_password': newPassword},
  );

  static Duration _seconds(Object? value, {required int fallback}) =>
      Duration(seconds: value is int && value >= 0 ? value : fallback);
}
