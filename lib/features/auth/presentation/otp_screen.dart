import 'dart:async';

import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/sms/sms_code_listener.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/iran_mobile.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/widgets/error_message.dart';
import 'package:caspian_owner/features/auth/application/account_flow.dart';
import 'package:caspian_owner/features/auth/domain/account_repository.dart';
import 'package:caspian_owner/features/auth/presentation/flow_expired.dart';
import 'package:caspian_owner/features/auth/presentation/widgets/auth_page.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Step 2 of 3 (registration and forgotten password): the 6-digit SMS
/// code. Android may fill it in after the owner allows reading that one
/// SMS; typing it always works. «ارسال دوباره کد» waits as long as the
/// server says.
class OtpScreen extends ConsumerStatefulWidget {
  const new({super.key});

  static const codeLength = 6;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _code = TextEditingController();
  late final SmsCodeListener _sms = ref.read(smsCodeListenerProvider);
  Timer? _ticker;
  bool _busy = false;
  bool _resending = false;
  String? _error;
  String? _notice;

  /// The resend wait ran out at least once: the code may never come.
  bool _waitedInVain = false;
  bool _counting = true;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    unawaited(_listenForSms());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    unawaited(_sms.cancel());
    _code.dispose();
    super.dispose();
  }

  Duration _untilResend(AccountFlow flow) =>
      flow.resendAt.difference(clock.now());

  /// Redraws once a second while the resend countdown runs, and once more
  /// when it ends; idle afterwards.
  void _tick() {
    final flow = ref.read(accountFlowProvider);
    if (!mounted || flow == null) return;
    final counting = _untilResend(flow) > Duration.zero;
    if (!counting && !_counting) return;
    setState(() {
      _counting = counting;
      if (!counting) _waitedInVain = true;
    });
  }

  Future<void> _listenForSms() async {
    final code = await _sms.nextCode();
    if (code == null || !mounted || _busy) return;
    _code.text = code;
    await _verify();
  }

  Future<void> _verify() async {
    final l10n = AppLocalizations.of(context);
    final code = toLatinDigits(_code.text.trim());
    if (code.length != OtpScreen.codeLength) {
      setState(() => _error = l10n.otpTooShort);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _notice = null;
    });
    try {
      await ref.read(accountFlowProvider.notifier).verify(code);
      unawaited(_sms.cancel());
      if (mounted) unawaited(context.push(Routes.newPassword));
    } on Object catch (e) {
      if (!mounted) return;
      final dead =
          e is ServerException &&
          (e.code == 'code_expired' || e.code == 'code_attempts_exceeded');
      setState(() {
        _error = errorMessage(e, l10n);
        if (dead || e is ServerException && e.code == 'code_wrong') {
          _code.clear();
        }
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    final l10n = AppLocalizations.of(context);
    final flow = ref.read(accountFlowProvider.notifier);
    setState(() {
      _resending = true;
      _error = null;
      _notice = null;
    });
    try {
      await flow.resend();
      _counting = true;
      _code.clear();
      if (mounted) setState(() => _notice = l10n.otpResent);
      await _sms.cancel();
      unawaited(_listenForSms());
    } on Object catch (e) {
      if (e case ServerException(:final retryAfter?)) {
        flow.waitBeforeResend(retryAfter);
        _counting = true;
      }
      if (mounted) setState(() => _error = errorMessage(e, l10n));
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final flow = ref.watch(accountFlowProvider);
    if (flow == null) return const FlowExpired();

    final untilResend = _untilResend(flow);
    final canResend = untilResend <= Duration.zero;

    return AuthPage(
      step: (2, 3),
      icon: AppIcons.sms,
      title: l10n.otpTitle,
      body: l10n.otpSentTo(IranMobile.display(flow.mobile)),
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: _busy ? null : () => context.pop(),
            icon: const Icon(AppIcons.edit),
            label: Text(l10n.otpChangeMobile),
          ),
        ),
        const SizedBox(height: Space.sm),
        TextField(
          controller: _code,
          enabled: !_busy,
          autofocus: true,
          keyboardType: TextInputType.number,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          autofillHints: const [AutofillHints.oneTimeCode],
          style: theme.textTheme.headlineMedium?.copyWith(letterSpacing: 12),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9۰-۹٠-٩]')),
            LengthLimitingTextInputFormatter(OtpScreen.codeLength),
          ],
          onChanged: (value) {
            if (value.length == OtpScreen.codeLength) unawaited(_verify());
          },
          onSubmitted: (_) => _verify(),
          decoration: InputDecoration(
            labelText: l10n.otpLabel,
            helperText: l10n.otpAutoFillNote,
            helperMaxLines: 3,
          ),
        ),
        if (_error case final error?) ...[
          const SizedBox(height: Space.md),
          FormMessage(error),
        ] else if (_notice case final notice?) ...[
          const SizedBox(height: Space.md),
          FormMessage(notice, kind: MessageKind.success),
        ],
        const SizedBox(height: Space.lg),
        BigButton(label: l10n.otpVerify, busy: _busy, onPressed: _verify),
        const SizedBox(height: Space.md),
        if (canResend)
          SecondButton(
            label: l10n.otpResend,
            onPressed: _busy || _resending ? null : _resend,
          )
        else
          Text(
            l10n.otpResendIn(formatWait(untilResend)),
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        // The server doesn't say whether a number already has an account
        // (no SMS is sent then); after waiting in vain, suggest the reset.
        if (flow.purpose == OtpPurpose.register && _waitedInVain) ...[
          const SizedBox(height: Space.lg),
          FormMessage(l10n.otpNoCodeRegister, kind: MessageKind.info),
          Center(
            child: TextButton(
              onPressed: () {
                ref.read(accountFlowProvider.notifier).cancel();
                context.go(Routes.forgotPassword);
              },
              child: Text(l10n.loginForgot),
            ),
          ),
        ],
      ],
    );
  }
}
