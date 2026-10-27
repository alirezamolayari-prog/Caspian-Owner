import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_colors.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/widgets/error_message.dart';
import 'package:caspian_owner/features/auth/application/account_flow.dart';
import 'package:caspian_owner/features/auth/domain/account_repository.dart';
import 'package:caspian_owner/features/auth/domain/account_rules.dart';
import 'package:caspian_owner/features/auth/presentation/flow_expired.dart';
import 'package:caspian_owner/features/auth/presentation/widgets/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// What the new password is for.
enum NewPasswordMode {
  /// Registration, step 3 of 3.
  register,

  /// Forgotten password, step 3 of 3.
  reset,

  /// The admin's first password must be replaced (`must_change_password`).
  changeFirst,
}

/// Choose a password, type it again, see the rules being met as you type.
class NewPasswordScreen extends ConsumerStatefulWidget {
  const new({required this.mode, super.key});

  final NewPasswordMode mode;

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final _password = TextEditingController();
  final _repeat = TextEditingController();
  bool _busy = false;
  bool _tried = false;
  String? _passwordError;
  String? _repeatError;
  String? _error;

  /// The verified token was used up or ran out: only starting over helps.
  bool _restart = false;

  @override
  void dispose() {
    _password.dispose();
    _repeat.dispose();
    super.dispose();
  }

  String? _problemText(Set<PasswordProblem> problems, AppLocalizations l10n) {
    if (problems.contains(PasswordProblem.tooShort)) {
      return l10n.passwordRuleLength;
    }
    if (problems.contains(PasswordProblem.tooRepetitive)) {
      return l10n.passwordRuleDistinct;
    }
    if (problems.contains(PasswordProblem.tooLong)) return l10n.passwordTooLong;
    if (problems.contains(PasswordProblem.tooCommon)) {
      return l10n.passwordTooCommon;
    }
    return null;
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final password = _password.text;
    setState(() {
      _tried = true;
      _passwordError = _problemText(PasswordRules.problems(password), l10n);
      _repeatError = _passwordError == null && _repeat.text != password
          ? l10n.passwordMismatch
          : null;
      _error = null;
    });
    if (_passwordError != null || _repeatError != null) return;

    setState(() => _busy = true);
    try {
      switch (widget.mode) {
        case NewPasswordMode.register:
          await ref.read(accountFlowProvider.notifier).finish(password);
          if (mounted) context.go(Routes.registered);
        case NewPasswordMode.reset:
          await ref.read(accountFlowProvider.notifier).finish(password);
          if (mounted) context.go(Routes.login);
        case NewPasswordMode.changeFirst:
          // Logs in afterwards; the router then leaves this page.
          await ref.read(passwordChangeProvider.notifier).complete(password);
      }
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        switch (e) {
          case ValidationException(:final fieldErrors)
              when fieldErrors.isNotEmpty:
            _passwordError =
                fieldErrors['password'] ??
                fieldErrors['new_password'] ??
                fieldErrors.values.first;
          case ServerException(code: 'verification_invalid'):
            _restart = true;
            _error = errorMessage(e, l10n);
          default:
            _error = errorMessage(e, l10n);
        }
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _startOver() {
    final purpose = ref.read(accountFlowProvider)?.purpose;
    ref.read(accountFlowProvider.notifier).cancel();
    context.go(
      purpose == OtpPurpose.register ? Routes.register : Routes.forgotPassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final flowMissing = switch (widget.mode) {
      NewPasswordMode.changeFirst => ref.watch(passwordChangeProvider) == null,
      _ => ref.watch(accountFlowProvider)?.verifiedToken == null,
    };
    if (flowMissing && !_busy) return const FlowExpired();

    final (title, body, submit) = switch (widget.mode) {
      NewPasswordMode.register => (
        l10n.passwordCreateTitle,
        l10n.passwordBody,
        l10n.registerSubmit,
      ),
      NewPasswordMode.reset => (
        l10n.passwordResetTitle,
        l10n.passwordBody,
        l10n.resetSubmit,
      ),
      NewPasswordMode.changeFirst => (
        l10n.passwordChangeTitle,
        l10n.passwordChangeBody,
        l10n.changeSubmit,
      ),
    };
    final problems = PasswordRules.problems(_password.text);

    return AuthPage(
      step: widget.mode == NewPasswordMode.changeFirst ? null : (3, 3),
      icon: AppIcons.lock,
      title: title,
      body: body,
      onBack: widget.mode == NewPasswordMode.changeFirst
          ? () {
              ref.read(passwordChangeProvider.notifier).change = null;
              context.go(Routes.login);
            }
          : null,
      children: [
        PasswordField(
          controller: _password,
          enabled: !_busy,
          isNew: true,
          label: l10n.passwordNewLabel,
          errorText: _tried ? _passwordError : null,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() {
            if (_tried) {
              _passwordError = _problemText(
                PasswordRules.problems(_password.text),
                l10n,
              );
            }
          }),
        ),
        const SizedBox(height: Space.sm),
        _Rule(
          met: !problems.contains(PasswordProblem.tooShort),
          text: l10n.passwordRuleLength,
        ),
        _Rule(
          met: !problems.contains(PasswordProblem.tooRepetitive),
          text: l10n.passwordRuleDistinct,
        ),
        const SizedBox(height: Space.md),
        PasswordField(
          controller: _repeat,
          enabled: !_busy,
          isNew: true,
          label: l10n.passwordRepeatLabel,
          errorText: _repeatError,
          onSubmitted: (_) => _submit(),
        ),
        if (_error case final error?) ...[
          const SizedBox(height: Space.md),
          FormMessage(error),
        ],
        const SizedBox(height: Space.lg),
        if (_restart)
          BigButton(label: l10n.flowRestart, onPressed: _startOver)
        else
          BigButton(label: submit, busy: _busy, onPressed: _submit),
      ],
    );
  }
}

/// One password rule, with its state in words for screen readers.
class _Rule extends StatelessWidget {
  const new({required this.met, required this.text});

  final bool met;
  final String text;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final color = met
        ? AppColors.of(context).success
        : theme.colorScheme.onSurfaceVariant;
    return MergeSemantics(
      child: Semantics(
        label: met ? l10n.passwordRuleOk : l10n.passwordRuleNotYet,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.xs),
          child: Row(
            children: [
              Icon(met ? AppIcons.approved : AppIcons.pending, color: color),
              const SizedBox(width: Space.sm),
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.bodyLarge?.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
