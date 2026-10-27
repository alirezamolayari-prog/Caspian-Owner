import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/iran_mobile.dart';
import 'package:caspian_owner/core/widgets/error_message.dart';
import 'package:caspian_owner/features/auth/application/account_flow.dart';
import 'package:caspian_owner/features/auth/domain/account_repository.dart';
import 'package:caspian_owner/features/auth/presentation/register_screen.dart';
import 'package:caspian_owner/features/auth/presentation/widgets/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Forgotten password, step 1 of 3: the mobile number, then «ارسال کد».
/// The server sends an SMS only to active accounts, but answers the same
/// either way.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _mobile = TextEditingController();
  bool _busy = false;
  String? _mobileError;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (ref.read(loginHintProvider) case LoginHint(:final mobile)) {
      _mobile.text = mobile;
    }
  }

  @override
  void dispose() {
    _mobile.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final l10n = AppLocalizations.of(context);
    final mobile = IranMobile.normalize(_mobile.text);
    setState(() {
      _mobileError = mobile == null ? l10n.mobileInvalid : null;
      _error = null;
    });
    if (mobile == null) return;

    setState(() => _busy = true);
    try {
      await ref
          .read(accountFlowProvider.notifier)
          .start(purpose: OtpPurpose.resetPassword, mobile: mobile);
      if (mounted) await context.push(Routes.otp);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        if (e case ServerException(code: 'invalid_mobile', :final messageFa)) {
          _mobileError = messageFa ?? l10n.mobileInvalid;
        } else {
          _error = errorMessage(e, l10n);
        }
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AuthPage(
      step: (1, 3),
      icon: AppIcons.lock,
      title: l10n.forgotTitle,
      body: l10n.forgotBody,
      children: [
        MobileField(
          controller: _mobile,
          enabled: !_busy,
          errorText: _mobileError,
          onSubmitted: (_) => _sendCode(),
        ),
        if (_error case final error?) ...[
          const SizedBox(height: Space.md),
          FormMessage(error),
        ],
        const SizedBox(height: Space.lg),
        BigButton(
          label: l10n.sendCode,
          icon: AppIcons.sms,
          busy: _busy,
          onPressed: _sendCode,
        ),
        const SizedBox(height: Space.md),
        Center(
          child: TextButton(
            onPressed: () => context.go(Routes.login),
            child: Text(l10n.backToLogin),
          ),
        ),
      ],
    );
  }
}
