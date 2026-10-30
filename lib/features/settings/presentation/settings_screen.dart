import 'dart:async';

import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/notifications/background_reliability.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/core/security/device_authenticator.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/update/update_controller.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/widgets/safe_bottom.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:caspian_owner/features/settings/presentation/server_url_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «تنظیمات»: theme, notifications (and what stops them while the app is
/// closed), fingerprint, screenshots, server address, app PIN.
class SettingsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final lock = ref.watch(appLockControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreSettings)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: Space.sm)
            .withSafeBottom(context),
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
          if (settings.notifications &&
              ref.watch(backgroundReliabilityProvider) != null)
            const _BackgroundSection(),
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
          if (lock.deviceAuthAvailable)
            SwitchListTile(
              title: Text(l10n.settingsDeviceUnlock),
              subtitle: Text(l10n.settingsDeviceUnlockBody),
              value: lock.useDevice,
              onChanged: (enabled) {
                final controller = ref.read(appLockControllerProvider.notifier);
                if (enabled) {
                  unawaited(
                    controller.enableDeviceUnlock(
                      AuthPrompt.of(l10n, l10n.unlockOfferReason),
                    ),
                  );
                } else {
                  // Without a PIN, the app asks for one next.
                  unawaited(controller.declineDeviceUnlock());
                }
              },
            ),
          if (ApiConfig.serverUrlEditable)
            ListTile(
              title: Text(l10n.serverTitle),
              subtitle: Text(
                settings.serverUrl,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.end,
              ),
              trailing: const Icon(AppIcons.server),
              onTap: () async {
                final saved = await showServerUrlDialog(context);
                if (saved && context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(l10n.serverSaved)));
                }
              },
            ),
          ListTile(
            title: Text(l10n.settingsPin),
            subtitle: Text(l10n.settingsPinBody),
            trailing: TextButton(
              onPressed: () => _setPin(context, ref),
              child: Text(l10n.settingsPinSet),
            ),
          ),
          const Divider(),
          // Also in «بیشتر»; here too, where owners look for the version.
          ListTile(
            leading: const Icon(AppIcons.about),
            title: Text(l10n.moreAbout),
            trailing: ref.watch(availableUpdateProvider) == null
                ? null
                : Badge(label: Text(l10n.settingsUpdateBadge)),
            onTap: () => context.push(Routes.about),
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

/// «اعلان وقتی برنامه بسته است»: each thing that can stop the background
/// check, its state as text, and a button to the system page that fixes it.
/// Read again when the owner comes back to the app.
class _BackgroundSection extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_BackgroundSection> createState() => _BackgroundSectionState();
}

class _BackgroundSectionState extends ConsumerState<_BackgroundSection> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () => ref.invalidate(backgroundStatusProvider),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final status = ref.watch(backgroundStatusProvider).value;
    final reliability = ref.watch(backgroundReliabilityProvider);
    if (status == null || reliability == null) return const SizedBox.shrink();

    Widget row({
      required String title,
      required String subtitle,
      required Future<void> Function() open,
      bool showButton = true,
    }) => ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: showButton
          ? TextButton(onPressed: open, child: Text(l10n.backgroundFix))
          : null,
    );

    String state({required bool on}) =>
        on ? l10n.backgroundOn : l10n.backgroundOff;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Space.page,
            Space.md,
            Space.page,
            Space.xs,
          ),
          child: Text(l10n.backgroundTitle, style: theme.textTheme.titleSmall),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.page),
          child: Text(l10n.backgroundBody, style: theme.textTheme.bodySmall),
        ),
        row(
          title: l10n.backgroundNotifications,
          subtitle: state(on: status.notificationsAllowed),
          open: reliability.openNotificationSettings,
          showButton: !status.notificationsAllowed,
        ),
        row(
          title: l10n.backgroundBattery,
          subtitle: state(on: status.batteryUnrestricted),
          open: reliability.openBatterySettings,
          showButton: !status.batteryUnrestricted,
        ),
        if (status.hasAutostart)
          row(
            title: l10n.backgroundAutostart,
            subtitle: l10n.backgroundAutostartBody,
            open: reliability.openAutostartSettings,
          ),
        const SizedBox(height: Space.sm),
      ],
    );
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
