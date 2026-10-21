import 'package:caspian_owner/core/brand/brand.dart';
import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/widgets/error_message.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:caspian_owner/features/settings/presentation/server_url_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Login with the username and password the server admin gave the owner
/// (Caspian Server `POST /auth/login`). The server address can be changed
/// here too, before logging in.
class LoginScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _showPassword = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context);
    final username = _username.text.trim();
    final password = _password.text;
    if (username.isEmpty || password.isEmpty) {
      setState(() => _error = l10n.loginFieldsRequired);
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
    } on Object catch (e) {
      if (mounted) {
        setState(
          () => _error = errorMessage(
            e,
            AppLocalizations.of(context),
            atLogin: true,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final auth = ref.watch(authControllerProvider);
    final serverUrl = ref.watch(
      settingsControllerProvider.select((s) => s.serverUrl),
    );
    final isMock = ref.watch(dataSourceProvider) == DataSource.mock;
    final signedOutBecause = switch (auth) {
      SignedOut(reason: SignOutReason.tooManyPinAttempts) =>
        l10n.signedOutTooManyAttempts,
      SignedOut(reason: SignOutReason.sessionExpired) =>
        l10n.signedOutSessionExpired,
      _ => null,
    };

    return Scaffold(
      body: SafeArea(
        child: AutofillGroup(
          child: ListView(
            padding: const EdgeInsets.all(Space.lg),
            children: [
              const SizedBox(height: Space.xl),
              Icon(
                AppIcons.account,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: Space.md),
              Text(l10n.loginTitle, style: theme.textTheme.headlineSmall),
              const SizedBox(height: Space.sm),
              Text(Brand.mallNameFa, style: theme.textTheme.bodySmall),
              if (signedOutBecause != null) ...[
                const SizedBox(height: Space.md),
                Text(
                  signedOutBecause,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: Space.lg),
              TextField(
                controller: _username,
                enabled: !_busy,
                autofocus: true,
                textDirection: TextDirection.ltr,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.username],
                decoration: InputDecoration(labelText: l10n.loginUsernameLabel),
              ),
              const SizedBox(height: Space.md),
              TextField(
                controller: _password,
                enabled: !_busy,
                obscureText: !_showPassword,
                textDirection: TextDirection.ltr,
                autocorrect: false,
                enableSuggestions: false,
                autofillHints: const [AutofillHints.password],
                onSubmitted: (_) => _login(),
                decoration: InputDecoration(
                  labelText: l10n.loginPasswordLabel,
                  errorText: _error,
                  errorMaxLines: 3,
                  // The mock accepts only the test password; say so there.
                  helperText: isMock ? l10n.loginTestPasswordHint : null,
                  suffixIcon: IconButton(
                    tooltip: _showPassword
                        ? l10n.loginHidePassword
                        : l10n.loginShowPassword,
                    icon: Icon(
                      _showPassword
                          ? AppIcons.visibilityOff
                          : AppIcons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  ),
                ),
              ),
              const SizedBox(height: Space.lg),
              _PrimaryButton(
                label: l10n.loginVerify,
                busy: _busy,
                onPressed: _login,
              ),
              if (!isMock) ...[
                const SizedBox(height: Space.lg),
                Text(
                  l10n.loginServer(serverUrl),
                  style: theme.textTheme.bodySmall,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.end,
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    onPressed: _busy
                        ? null
                        : () => showServerUrlDialog(context),
                    child: Text(l10n.loginChangeServer),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
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
