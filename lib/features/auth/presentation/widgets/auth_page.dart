import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_colors.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:flutter/material.dart';

/// Account pages are for owners aged 55–65: larger text and buttons than
/// the rest of the app, one main action per page, Google-style.
abstract final class AuthSizes {
  /// Typed text and button labels.
  static const inputFont = 18.0;

  /// Height of the main buttons.
  static const buttonHeight = 56.0;

  /// Pages don't stretch on tablets or in landscape.
  static const maxWidth = 480.0;
}

/// The frame of every account page: optional back button, an icon, a big
/// title, a short explanation and the page's fields and buttons.
class AuthPage extends StatelessWidget {
  const new({
    required this.title,
    required this.children,
    this.icon,
    this.body,
    this.step,
    this.showBack = true,
    this.onBack,
    super.key,
  });

  final String title;
  final String? body;
  final IconData? icon;

  /// `(2, 3)` shows «مرحله ۲ از ۳».
  final (int, int)? step;
  final bool showBack;

  /// Instead of simply going back (e.g. also ending a flow).
  final VoidCallback? onBack;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final step = this.step;
    return Scaffold(
      appBar: showBack
          ? AppBar(
              leading: BackButton(onPressed: onBack),
              title: step == null
                  ? null
                  : Text(
                      l10n.stepOf(
                        toPersianDigits('${step.$1}'),
                        toPersianDigits('${step.$2}'),
                      ),
                      style: theme.textTheme.titleMedium,
                    ),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AuthSizes.maxWidth),
            child: AutofillGroup(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  Space.lg,
                  Space.md,
                  Space.lg,
                  Space.xl,
                ),
                children: [
                  if (!showBack) const SizedBox(height: Space.xl),
                  if (icon != null) ...[
                    Icon(icon, size: 56, color: theme.colorScheme.primary),
                    const SizedBox(height: Space.md),
                  ],
                  Semantics(
                    header: true,
                    child: Text(title, style: theme.textTheme.headlineSmall),
                  ),
                  if (body != null) ...[
                    const SizedBox(height: Space.sm),
                    Text(
                      body!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: Space.lg),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The page's main action: full width, tall, with progress while [busy].
class BigButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.icon,
    super.key,
  });

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;
  final bool busy;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(AuthSizes.buttonHeight),
      textStyle: Theme.of(context).textTheme.titleMedium
          ?.copyWith(fontSize: AuthSizes.inputFont),
    );
    final child = busy
        ? Semantics(
            label: label,
            child: const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          )
        : Text(label, textAlign: TextAlign.center);
    return icon == null || busy
        ? FilledButton(
            style: style,
            onPressed: busy ? null : onPressed,
            child: child,
          )
        : FilledButton.icon(
            style: style,
            onPressed: onPressed,
            icon: Icon(icon),
            label: child,
          );
  }
}

/// A second, quieter choice under the main button.
class SecondButton extends StatelessWidget {
  const new({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(AuthSizes.buttonHeight),
      textStyle: Theme.of(context).textTheme.titleMedium
          ?.copyWith(fontSize: AuthSizes.inputFont),
    ),
    onPressed: onPressed,
    child: Text(label, textAlign: TextAlign.center),
  );
}

/// Text style for what owners type on account pages.
TextStyle? authInputStyle(BuildContext context) =>
    Theme.of(context).textTheme.titleMedium
        ?.copyWith(fontSize: AuthSizes.inputFont, fontWeight: FontWeight.w500);

/// A password with «نمایش رمز» / «پنهان کردن رمز». Paste and password
/// managers work (no copy blocking).
class PasswordField extends StatefulWidget {
  const new({
    required this.controller,
    required this.label,
    this.errorText,
    this.helperText,
    this.enabled = true,
    this.isNew = false,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? errorText;
  final String? helperText;
  final bool enabled;

  /// A password being created (autofill offers to save it).
  final bool isNew;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: !_visible,
      style: authInputStyle(context),
      textDirection: TextDirection.ltr,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: widget.textInputAction,
      autofillHints: [
        if (widget.isNew) AutofillHints.newPassword else AutofillHints.password,
      ],
      onSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: widget.errorText,
        errorMaxLines: 3,
        helperText: widget.helperText,
        helperMaxLines: 3,
        suffixIcon: IconButton(
          tooltip: _visible ? l10n.loginHidePassword : l10n.loginShowPassword,
          icon: Icon(_visible ? AppIcons.visibilityOff : AppIcons.visibility),
          onPressed: () => setState(() => _visible = !_visible),
        ),
      ),
    );
  }
}

enum MessageKind { error, info, success }

/// A message box: the meaning is in the icon and the words, never only
/// the color. Read out by screen readers when it appears.
class FormMessage extends StatelessWidget {
  const new(this.text, {this.kind = MessageKind.error, super.key});

  final String text;
  final MessageKind kind;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = AppColors.of(context);
    final (background, foreground, icon) = switch (kind) {
      MessageKind.error => (
        scheme.errorContainer,
        scheme.onErrorContainer,
        AppIcons.error,
      ),
      MessageKind.info => (
        scheme.surfaceContainerHigh,
        scheme.onSurface,
        AppIcons.about,
      ),
      MessageKind.success => (
        colors.successContainer,
        scheme.onSurface,
        AppIcons.approved,
      ),
    };
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(Space.md),
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.all(Radius.circular(Radii.chip)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: foreground),
            const SizedBox(width: Space.sm),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// «۱:۲۵», «۱:۰۵:۰۰» for a wait, with Persian digits. Rounds up, so the
/// owner is never told it's time a moment too early.
String formatWait(Duration wait) {
  final ms = wait.isNegative ? 0 : wait.inMilliseconds;
  final seconds = (ms + 999) ~/ 1000;
  final h = seconds ~/ 3600;
  final m = (seconds % 3600) ~/ 60;
  final s = (seconds % 60).toString().padLeft(2, '0');
  final text = h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
  return toPersianDigits(text);
}
