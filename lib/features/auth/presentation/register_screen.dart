import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/iran_mobile.dart';
import 'package:caspian_owner/core/widgets/error_message.dart';
import 'package:caspian_owner/features/auth/application/account_flow.dart';
import 'package:caspian_owner/features/auth/domain/account_repository.dart';
import 'package:caspian_owner/features/auth/domain/account_rules.dart';
import 'package:caspian_owner/features/auth/presentation/widgets/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Registration, step 1 of 3: first name, last name and mobile, then
/// «ارسال کد». The names are only sent at the last step.
class RegisterScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _mobile = TextEditingController();
  bool _busy = false;
  String? _firstNameError;
  String? _lastNameError;
  String? _mobileError;
  String? _error;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _mobile.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final l10n = AppLocalizations.of(context);
    final firstName = PersonName.normalize(_firstName.text);
    final lastName = PersonName.normalize(_lastName.text);
    final mobile = IranMobile.normalize(_mobile.text);
    setState(() {
      _firstNameError = firstName == null ? l10n.nameInvalid : null;
      _lastNameError = lastName == null ? l10n.nameInvalid : null;
      _mobileError = mobile == null ? l10n.mobileInvalid : null;
      _error = null;
    });
    if (firstName == null || lastName == null || mobile == null) return;

    setState(() => _busy = true);
    try {
      await ref
          .read(accountFlowProvider.notifier)
          .start(
            purpose: OtpPurpose.register,
            mobile: mobile,
            firstName: firstName,
            lastName: lastName,
          );
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

    TextField nameField(
      TextEditingController controller,
      String label,
      String? error,
      Iterable<String> autofill,
    ) => TextField(
      controller: controller,
      enabled: !_busy,
      style: authInputStyle(context),
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      autofillHints: autofill,
      decoration: InputDecoration(labelText: label, errorText: error),
    );

    return AuthPage(
      step: (1, 3),
      icon: AppIcons.account,
      title: l10n.registerTitle,
      body: l10n.registerBody,
      children: [
        nameField(_firstName, l10n.registerFirstName, _firstNameError, const [
          AutofillHints.givenName,
        ]),
        const SizedBox(height: Space.md),
        nameField(_lastName, l10n.registerLastName, _lastNameError, const [
          AutofillHints.familyName,
        ]),
        const SizedBox(height: Space.md),
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
            child: Text(l10n.registerHaveAccount),
          ),
        ),
      ],
    );
  }
}

/// «شماره موبایل»: phone keypad, Persian or Latin digits, left to right.
class MobileField extends StatelessWidget {
  const new({
    required this.controller,
    this.enabled = true,
    this.errorText,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: controller,
      enabled: enabled,
      style: authInputStyle(context),
      keyboardType: TextInputType.phone,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.telephoneNumber],
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: l10n.loginMobileLabel,
        hintText: l10n.loginMobileHint,
        hintTextDirection: TextDirection.rtl,
        errorText: errorText,
        errorMaxLines: 3,
      ),
    );
  }
}
