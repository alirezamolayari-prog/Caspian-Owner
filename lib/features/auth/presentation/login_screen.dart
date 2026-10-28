import 'dart:async';

import 'package:caspian_owner/core/brand/brand.dart';
import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/iran_mobile.dart';
import 'package:caspian_owner/core/widgets/error_message.dart';
import 'package:caspian_owner/features/auth/application/account_flow.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/auth/domain/auth_repository.dart';
import 'package:caspian_owner/features/auth/presentation/widgets/auth_page.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:caspian_owner/features/settings/presentation/server_url_dialog.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Everyday login: mobile number (or, for admin accounts, a username) and
/// password (`POST /auth/login`, no SMS). Links to «رمز را فراموش کرده‌ام»
/// and «ثبت‌نام مالک جدید».
class LoginScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _id = TextEditingController();
  final _password = TextEditingController();
  bool _useUsername = false;
  bool _busy = false;
  String? _error;

  /// After `login_rate_limited`: the button waits until then.
  DateTime? _blockedUntil;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    if (ref.read(loginHintProvider) case LoginHint(:final mobile)) {
      _id.text = mobile;
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _id.dispose();
    _password.dispose();
    super.dispose();
  }

  Duration get _wait => _blockedUntil?.difference(clock.now()) ?? Duration.zero;

  void _blockFor(Duration wait) {
    _blockedUntil = clock.now().add(wait);
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {});
      if (_wait <= Duration.zero) {
        timer.cancel();
        _blockedUntil = null;
      }
    });
  }

  /// `account_pending`, `account_rejected`, `account_disabled`.
  static const _account = 'account_';

  /// A username has Latin letters; anything else must be a mobile number.
  static bool _isUsername(String id) => RegExp('[A-Za-z]').hasMatch(id);

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context);
    final id = _id.text.trim();
    final password = _password.text;
    if (id.isEmpty || password.isEmpty) {
      setState(() => _error = l10n.loginFieldsRequired);
      return;
    }
    final username = _isUsername(id) ? id : IranMobile.normalize(id);
    if (username == null) {
      setState(() => _error = l10n.mobileInvalid);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(username: username, password: password);
      ref.read(loginHintProvider.notifier).hint = null;
    } on MustChangePasswordException catch (e) {
      ref.read(passwordChangeProvider.notifier).change = PasswordChange(
        username: username,
        currentPassword: password,
        accessToken: e.accessToken,
      );
      if (mounted) unawaited(context.push(Routes.changePassword));
    } on Object catch (e) {
      if (!mounted) return;
      if (e case ServerException(:final code) when code.startsWith(_account)) {
        // Pending, rejected or disabled: a page of its own explains it.
        _password.clear();
        unawaited(
          context.push(Routes.accountStatus(code.substring(_account.length))),
        );
        return;
      }
      if (e case ServerException(statusCode: 429, :final retryAfter?)) {
        _blockFor(retryAfter);
      }
      setState(() => _error = errorMessage(e, l10n, atLogin: true));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final auth = ref.watch(authControllerProvider);
    final isMock = ref.watch(dataSourceProvider) == DataSource.mock;
    final signedOutBecause = switch (auth) {
      SignedOut(reason: SignOutReason.tooManyPinAttempts) =>
        l10n.signedOutTooManyAttempts,
      SignedOut(reason: SignOutReason.sessionExpired) =>
        l10n.signedOutSessionExpired,
      _ => null,
    };
    // Just registered or reset the password: say so, fill in the mobile.
    ref.listen(loginHintProvider, (_, next) {
      if (next == null) return;
      _id.text = next.mobile;
      _password.clear();
      setState(() => _error = null);
    });
    final hint = switch (ref.watch(loginHintProvider)?.reason) {
      LoginHintReason.registered => l10n.loginRegisteredNotice,
      LoginHintReason.passwordReset => l10n.loginPasswordResetNotice,
      LoginHintReason.mobileTaken || null => null,
    };
    final blocked = _wait > Duration.zero;

    return AuthPage(
      showBack: false,
      icon: AppIcons.account,
      title: l10n.loginTitle,
      body: Brand.mallNameFa,
      children: [
        if (signedOutBecause != null) ...[
          FormMessage(signedOutBecause),
          const SizedBox(height: Space.md),
        ] else if (hint != null) ...[
          FormMessage(hint, kind: MessageKind.success),
          const SizedBox(height: Space.md),
        ],
        TextField(
          controller: _id,
          enabled: !_busy,
          style: authInputStyle(context),
          textDirection: TextDirection.ltr,
          autocorrect: false,
          keyboardType: _useUsername
              ? TextInputType.visiblePassword
              : TextInputType.phone,
          textInputAction: TextInputAction.next,
          autofillHints: [
            if (_useUsername)
              AutofillHints.username
            else
              AutofillHints.telephoneNumber,
          ],
          decoration: InputDecoration(
            labelText: _useUsername
                ? l10n.loginUsernameLabel
                : l10n.loginMobileLabel,
            hintText: _useUsername ? null : l10n.loginMobileHint,
            hintTextDirection: TextDirection.rtl,
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: _busy
                ? null
                : () => setState(() => _useUsername = !_useUsername),
            child: Text(
              _useUsername ? l10n.loginUseMobile : l10n.loginUseUsername,
            ),
          ),
        ),
        const SizedBox(height: Space.sm),
        PasswordField(
          controller: _password,
          enabled: !_busy,
          label: l10n.loginPasswordLabel,
          // The mock accepts only the test password; say so there.
          helperText: isMock ? l10n.loginTestPasswordHint : null,
          onSubmitted: (_) => blocked ? null : _login(),
        ),
        if (_error case final error?) ...[
          const SizedBox(height: Space.md),
          FormMessage(error),
        ],
        const SizedBox(height: Space.lg),
        BigButton(
          label: blocked
              ? l10n.loginWaitButton(formatWait(_wait))
              : l10n.loginVerify,
          busy: _busy,
          onPressed: blocked ? null : _login,
        ),
        const SizedBox(height: Space.sm),
        Center(
          child: TextButton(
            onPressed: _busy ? null : () => context.push(Routes.forgotPassword),
            child: Text(l10n.loginForgot),
          ),
        ),
        const SizedBox(height: Space.lg),
        Text(
          l10n.loginNoAccount,
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Space.sm),
        SecondButton(
          label: l10n.loginRegister,
          onPressed: _busy ? null : () => context.push(Routes.register),
        ),
        if (!isMock && ApiConfig.serverUrlEditable) const _ServerRow(),
      ],
    );
  }
}

/// Debug builds only: which server, and a way to change it.
class _ServerRow extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final serverUrl = ref.watch(
      settingsControllerProvider.select((s) => s.serverUrl),
    );
    return Padding(
      padding: const EdgeInsets.only(top: Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.loginServer(serverUrl),
            style: Theme.of(context).textTheme.bodySmall,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.end,
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: () => showServerUrlDialog(context),
              child: Text(l10n.loginChangeServer),
            ),
          ),
        ],
      ),
    );
  }
}
