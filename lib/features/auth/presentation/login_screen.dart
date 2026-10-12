import 'dart:async';

import 'package:caspian_owner/core/brand/brand.dart';
import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/widgets/error_message.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Login in two steps: phone number, then the SMS code.
class LoginScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static final _phonePattern = RegExp(r'^09\d{9}$');

  final _phone = TextEditingController();
  final _code = TextEditingController();

  /// Normalized phone once the code was sent; null on the phone step.
  String? _sentTo;
  int _codeLength = 5;
  int _resendIn = 0;
  Timer? _timer;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _timer?.cancel();
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final l10n = AppLocalizations.of(context);
    final phone = toLatinDigits(_phone.text.trim());
    if (!_phonePattern.hasMatch(phone)) {
      setState(() => _error = l10n.loginPhoneInvalid);
      return;
    }
    await _run(() async {
      final otp = await ref
          .read(authControllerProvider.notifier)
          .requestCode(phone);
      _code.clear();
      setState(() {
        _sentTo = phone;
        _codeLength = otp.codeLength;
      });
      _startCountdown(otp.resendAfter);
    });
  }

  Future<void> _verify() => _run(
    () => ref
        .read(authControllerProvider.notifier)
        .verify(phone: _sentTo!, code: toLatinDigits(_code.text.trim())),
  );

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorMessage(e, AppLocalizations.of(context)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _startCountdown(Duration duration) {
    _timer?.cancel();
    setState(() => _resendIn = duration.inSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _resendIn <= 1) timer.cancel();
      if (mounted) {
        setState(() => _resendIn = _resendIn > 0 ? _resendIn - 1 : 0);
      }
    });
  }

  void _changePhone() {
    _timer?.cancel();
    setState(() {
      _sentTo = null;
      _error = null;
      _resendIn = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final auth = ref.watch(authControllerProvider);
    final forcedOut =
        auth is SignedOut && auth.reason == SignOutReason.tooManyPinAttempts;
    final codeStep = _sentTo != null;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Space.lg),
          children: [
            const SizedBox(height: Space.xl),
            Icon(AppIcons.sms, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: Space.md),
            Text(l10n.loginTitle, style: theme.textTheme.headlineSmall),
            const SizedBox(height: Space.sm),
            Text(Brand.mallNameFa, style: theme.textTheme.bodySmall),
            if (forcedOut) ...[
              const SizedBox(height: Space.md),
              Text(
                l10n.signedOutTooManyAttempts,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: Space.lg),
            if (!codeStep) ..._phoneStep(l10n) else ..._codeStep(l10n),
          ],
        ),
      ),
    );
  }

  List<Widget> _phoneStep(AppLocalizations l10n) => [
    TextField(
      controller: _phone,
      enabled: !_busy,
      autofocus: true,
      keyboardType: TextInputType.phone,
      textDirection: TextDirection.ltr,
      autofillHints: const [AutofillHints.telephoneNumber],
      inputFormatters: [LengthLimitingTextInputFormatter(11)],
      onSubmitted: (_) => _sendCode(),
      decoration: InputDecoration(
        labelText: l10n.loginPhoneLabel,
        hintText: l10n.loginPhoneHint,
        helperText: l10n.loginPhoneHelp,
        errorText: _error,
      ),
    ),
    const SizedBox(height: Space.lg),
    _PrimaryButton(
      label: l10n.loginSendCode,
      busy: _busy,
      onPressed: _sendCode,
    ),
  ];

  List<Widget> _codeStep(AppLocalizations l10n) => [
    Text(
      l10n.loginCodeSent(_codeLength, toPersianDigits(_sentTo!)),
      style: Theme.of(context).textTheme.bodyMedium,
    ),
    const SizedBox(height: Space.md),
    TextField(
      controller: _code,
      enabled: !_busy,
      autofocus: true,
      keyboardType: TextInputType.number,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      autofillHints: const [AutofillHints.oneTimeCode],
      inputFormatters: [LengthLimitingTextInputFormatter(_codeLength)],
      onSubmitted: (_) => _verify(),
      decoration: InputDecoration(
        labelText: l10n.loginCodeLabel,
        errorText: _error,
        helperText: ref.watch(appInfoProvider).isDebug
            ? l10n.loginTestCodeHint
            : null,
      ),
    ),
    const SizedBox(height: Space.lg),
    _PrimaryButton(label: l10n.loginVerify, busy: _busy, onPressed: _verify),
    const SizedBox(height: Space.sm),
    Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _busy ? null : _changePhone,
          child: Text(l10n.loginChangePhone),
        ),
        TextButton(
          onPressed: _busy || _resendIn > 0 ? null : _sendCode,
          child: Text(
            _resendIn > 0 ? l10n.loginResendIn(_resendIn) : l10n.loginResend,
          ),
        ),
      ],
    ),
  ];
}

/// Full-width filled button that shows progress while [busy].
class _PrimaryButton extends StatelessWidget {
  const new({required this.label, required this.busy, required this.onPressed});

  final String label;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: busy ? null : onPressed,
      child: busy
          ? Semantics(
              label: label,
              child: const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : Text(label),
    );
  }
}
