/// What an SMS code is for. SMS login exists on the server but is off; the
/// app never asks for it.
enum OtpPurpose {
  register('register'),
  resetPassword('reset_password');

  new(this.wire);

  /// The value sent as `purpose`.
  final String wire;
}

/// `POST /auth/otp/request` answered: the code (if one was sent) lives
/// [expiresIn]; «ارسال دوباره» may be offered after [resendAfter]. The
/// answer is the same whether or not an SMS really went out.
class OtpSent {
  const new({required this.expiresIn, required this.resendAfter});

  final Duration expiresIn;
  final Duration resendAfter;
}

/// Registration and password reset with an SMS code, and changing a first
/// password (Caspian Server, owner-auth-api.md). Errors are
/// `ServerException`s with the server's code (`otp_cooldown`, `code_wrong`,
/// `verification_invalid`, …) and Persian message, or a
/// `ValidationException` naming the field.
abstract interface class AccountRepository {
  Future<OtpSent> requestCode({
    required String mobile,
    required OtpPurpose purpose,
  });

  /// The single-use `verified_token` (valid 5 minutes) for the next step.
  Future<String> verifyCode({
    required String mobile,
    required String code,
    required OtpPurpose purpose,
  });

  /// Creates the account; it waits for the admin's approval.
  Future<void> register({
    required String verifiedToken,
    required String firstName,
    required String lastName,
    required String password,
  });

  /// Sets a new password; every device that was logged in is logged out.
  Future<void> resetPassword({
    required String verifiedToken,
    required String newPassword,
  });

  /// The first password an admin gave must be replaced
  /// (`must_change_password`). [accessToken] is the login's token.
  Future<void> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  });
}
