import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Required on phones without any screen lock: the app PIN is then the
/// only thing protecting the data.
class PinSetupScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  static const pinLength = 4;

  final _pin = TextEditingController();
  final _repeat = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pin.dispose();
    _repeat.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final pin = toLatinDigits(_pin.text);
    if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
      setState(() => _error = l10n.pinTooShort);
      return;
    }
    if (pin != toLatinDigits(_repeat.text)) {
      setState(() => _error = l10n.pinMismatch);
      return;
    }
    await ref.read(appLockControllerProvider.notifier).setPin(pin);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    InputDecoration field(String label, {String? error}) =>
        InputDecoration(labelText: label, errorText: error);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Space.lg),
          children: [
            const SizedBox(height: Space.xl),
            Icon(AppIcons.lock, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: Space.md),
            Text(l10n.pinSetupTitle, style: theme.textTheme.headlineSmall),
            const SizedBox(height: Space.sm),
            Text(l10n.pinSetupBody, style: theme.textTheme.bodyMedium),
            const SizedBox(height: Space.lg),
            for (final (controller, label, error) in [
              (_pin, l10n.pinLabel, null),
              (_repeat, l10n.pinRepeatLabel, _error),
            ]) ...[
              TextField(
                controller: controller,
                obscureText: true,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                inputFormatters: [LengthLimitingTextInputFormatter(pinLength)],
                decoration: field(label, error: error),
              ),
              const SizedBox(height: Space.md),
            ],
            const SizedBox(height: Space.sm),
            FilledButton(onPressed: _save, child: Text(l10n.pinSave)),
          ],
        ),
      ),
    );
  }
}
