import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/auth/domain/account_repository.dart';
import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A registration or password reset in progress. Kept in memory only (the
/// verified token is never written to the phone); closing the app starts
/// the flow over.
class AccountFlow {
  const new({
    required this.purpose,
    required this.mobile,
    required this.resendAt,
    this.firstName = '',
    this.lastName = '',
    this.verifiedToken,
  });

  final OtpPurpose purpose;

  /// `09…`, as sent to the server.
  final String mobile;

  /// Registration only: kept here until the last step needs them.
  final String firstName;
  final String lastName;

  /// When «ارسال دوباره کد» may be offered (from `resend_after` or a 429's
  /// `Retry-After`).
  final DateTime resendAt;

  /// From a correct code; single use, valid 5 minutes.
  final String? verifiedToken;

  AccountFlow copyWith({DateTime? resendAt, String? verifiedToken}) =>
      AccountFlow(
        purpose: purpose,
        mobile: mobile,
        firstName: firstName,
        lastName: lastName,
        resendAt: resendAt ?? this.resendAt,
        verifiedToken: verifiedToken ?? this.verifiedToken,
      );
}

final accountFlowProvider =
    NotifierProvider<AccountFlowController, AccountFlow?>(
      AccountFlowController.new,
    );

/// Mobile → SMS code → password, for registering and for a forgotten
/// password (owner-auth-api.md). Errors are thrown to the screen, which
/// shows the server's message.
class AccountFlowController extends Notifier<AccountFlow?> {
  @override
  AccountFlow? build() => null;

  AccountRepository get _repository => ref.read(accountRepositoryProvider);

  /// Sends the first code and starts the flow.
  Future<void> start({
    required OtpPurpose purpose,
    required String mobile,
    String firstName = '',
    String lastName = '',
  }) async {
    final sent = await _repository.requestCode(
      mobile: mobile,
      purpose: purpose,
    );
    state = AccountFlow(
      purpose: purpose,
      mobile: mobile,
      firstName: firstName,
      lastName: lastName,
      resendAt: clock.now().add(sent.resendAfter),
    );
  }

  /// «ارسال دوباره کد».
  Future<void> resend() async {
    final flow = _flow;
    final sent = await _repository.requestCode(
      mobile: flow.mobile,
      purpose: flow.purpose,
    );
    state = flow.copyWith(resendAt: clock.now().add(sent.resendAfter));
  }

  /// The server said to wait (429 with `Retry-After`).
  void waitBeforeResend(Duration wait) {
    final flow = state;
    if (flow != null) state = flow.copyWith(resendAt: clock.now().add(wait));
  }

  /// Checks the SMS code; on success the password step may follow.
  Future<void> verify(String code) async {
    final flow = _flow;
    final token = await _repository.verifyCode(
      mobile: flow.mobile,
      code: code,
      purpose: flow.purpose,
    );
    state = flow.copyWith(verifiedToken: token);
  }

  /// Registers, or sets the new password. Ends the flow and fills in the
  /// mobile on the login screen.
  Future<void> finish(String password) async {
    final flow = _flow;
    final token = flow.verifiedToken;
    if (token == null) throw StateError('Code not verified');
    switch (flow.purpose) {
      case OtpPurpose.register:
        await _repository.register(
          verifiedToken: token,
          firstName: flow.firstName,
          lastName: flow.lastName,
          password: password,
        );
      case OtpPurpose.resetPassword:
        await _repository.resetPassword(
          verifiedToken: token,
          newPassword: password,
        );
    }
    ref.read(loginHintProvider.notifier).hint = LoginHint(
      mobile: flow.mobile,
      reason: flow.purpose == OtpPurpose.register
          ? LoginHintReason.registered
          : LoginHintReason.passwordReset,
    );
    state = null;
  }

  void cancel() => state = null;

  AccountFlow get _flow => state ?? (throw StateError('No account flow'));
}

enum LoginHintReason { registered, passwordReset, mobileTaken }

/// What the login screen should say and fill in after a flow ended.
class LoginHint {
  const new({required this.mobile, required this.reason});

  final String mobile;
  final LoginHintReason reason;
}

final loginHintProvider = NotifierProvider<LoginHintController, LoginHint?>(
  LoginHintController.new,
);

class LoginHintController extends Notifier<LoginHint?> {
  @override
  LoginHint? build() => null;

  /// Null once the login screen has used it.
  LoginHint? get hint => state;
  set hint(LoginHint? value) => state = value;
}

/// A login whose admin-given first password must be changed first. The
/// password stays in memory only until the change is done.
class PasswordChange {
  const new({
    required this.username,
    required this.currentPassword,
    required this.accessToken,
  });

  final String username;
  final String currentPassword;
  final String accessToken;
}

final passwordChangeProvider =
    NotifierProvider<PasswordChangeController, PasswordChange?>(
      PasswordChangeController.new,
    );

class PasswordChangeController extends Notifier<PasswordChange?> {
  @override
  PasswordChange? build() => null;

  PasswordChange? get change => state;
  set change(PasswordChange? value) => state = value;

  /// Changes the password, then logs in with the new one (the server may
  /// have ended the first token).
  Future<void> complete(String newPassword) async {
    final change = state ?? (throw StateError('No password change'));
    await ref
        .read(accountRepositoryProvider)
        .changePassword(
          accessToken: change.accessToken,
          currentPassword: change.currentPassword,
          newPassword: newPassword,
        );
    state = null;
    await ref
        .read(authControllerProvider.notifier)
        .login(username: change.username, password: newPassword);
  }
}
