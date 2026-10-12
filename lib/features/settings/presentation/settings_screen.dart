import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// «تنظیمات»: theme, notifications, fingerprint, screenshots, app PIN.
class SettingsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreSettings)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: Space.sm),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.page,
              Space.sm,
              Space.page,
              Space.sm,
            ),
            child: Text(l10n.settingsTheme, style: theme.textTheme.titleSmall),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.page),
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l10n.themeSystem),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l10n.themeLight),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l10n.themeDark),
                ),
              ],
              selected: {settings.themeMode},
              showSelectedIcon: false,
              onSelectionChanged: (s) => controller.themeMode = s.first,
            ),
          ),
          const SizedBox(height: Space.md),
          SwitchListTile(
            title: Text(l10n.settingsNotifications),
            subtitle: Text(l10n.settingsNotificationsBody),
            value: settings.notifications,
            onChanged: (v) => controller.setNotifications(enabled: v),
          ),
          SwitchListTile(
            title: Text(l10n.settingsFingerprint),
            subtitle: Text(l10n.settingsFingerprintBody),
            value: settings.fingerprintForApproval,
            onChanged: (v) => controller.setFingerprintForApproval(enabled: v),
          ),
          SwitchListTile(
            title: Text(l10n.settingsSecure),
            subtitle: Text(l10n.settingsSecureBody),
            value: settings.secureScreens,
            onChanged: (v) => controller.setSecureScreens(enabled: v),
          ),
          ListTile(
            title: Text(l10n.settingsPin),
            subtitle: Text(l10n.settingsPinBody),
            trailing: TextButton(
              onPressed: () => _setPin(context, ref),
              child: Text(l10n.settingsPinSet),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setPin(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final pin = await showDialog<String>(
      context: context,
      builder: (context) => const _PinDialog(),
    );
    if (pin == null) return;
    await ref.read(appLockControllerProvider.notifier).setPin(pin);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.settingsPinSaved)));
    }
  }
}

class _PinDialog extends StatefulWidget {
  const new();

  @override
  State<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<_PinDialog> {
  final _pin = TextEditingController();
  final _repeat = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pin.dispose();
    _repeat.dispose();
    super.dispose();
  }

  void _save() {
    final l10n = AppLocalizations.of(context);
    final pin = toLatinDigits(_pin.text);
    if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
      setState(() => _error = l10n.pinTooShort);
    } else if (pin != toLatinDigits(_repeat.text)) {
      setState(() => _error = l10n.pinMismatch);
    } else {
      Navigator.pop(context, pin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    TextField field(TextEditingController c, String label, String? error) =>
        TextField(
          controller: c,
          obscureText: true,
          keyboardType: TextInputType.number,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          inputFormatters: [LengthLimitingTextInputFormatter(4)],
          decoration: InputDecoration(labelText: label, errorText: error),
        );

    return AlertDialog(
      title: Text(l10n.settingsPin),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          field(_pin, l10n.pinLabel, null),
          const SizedBox(height: Space.md),
          field(_repeat, l10n.pinRepeatLabel, _error),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(onPressed: _save, child: Text(l10n.pinSave)),
      ],
    );
  }
}
