import 'dart:async';

import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/core/security/device_authenticator.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shown on launch and after 5 minutes in the background. The system
/// fingerprint/PIN prompt opens by itself, so it's one touch for owners.
class LockScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final _pin = TextEditingController();
  String? _pinError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && ref.read(appLockControllerProvider).deviceUnlock) {
        unawaited(_unlockWithDevice());
      }
    });
  }

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _unlockWithDevice() => ref
      .read(appLockControllerProvider.notifier)
      .unlockWithDevice(
        AuthPrompt.of(
          AppLocalizations.of(context),
          AppLocalizations.of(context).lockReason,
        ),
      );

  Future<void> _unlockWithPin() async {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(appLockControllerProvider.notifier);
    final ok = await controller.unlockWithPin(toLatinDigits(_pin.text));
    if (!ok && mounted) {
      _pin.clear();
      setState(
        () => _pinError = l10n.pinWrong(
          ref.read(appLockControllerProvider).pinAttemptsLeft,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lock = ref.watch(appLockControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Space.lg),
          children: [
            const SizedBox(height: Space.xl * 2),
            Icon(AppIcons.lock, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: Space.md),
            Text(
              l10n.lockTitle,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.sm),
            Text(
              l10n.lockBody,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.xl),
            if (lock.deviceUnlock)
              FilledButton.icon(
                onPressed: _unlockWithDevice,
                icon: const Icon(AppIcons.fingerprint),
                label: Text(l10n.lockUnlockDevice),
              ),
            if (lock.hasPin) ...[
              const SizedBox(height: Space.lg),
              TextField(
                controller: _pin,
                obscureText: true,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                inputFormatters: [LengthLimitingTextInputFormatter(4)],
                onSubmitted: (_) => _unlockWithPin(),
                decoration: InputDecoration(
                  labelText: l10n.pinLabel,
                  errorText: _pinError,
                ),
              ),
              const SizedBox(height: Space.md),
              OutlinedButton(
                onPressed: _unlockWithPin,
                child: Text(l10n.lockUsePin),
              ),
            ],
            const SizedBox(height: Space.lg),
            // Fingerprint not working: log in again with the password.
            Center(
              child: TextButton(
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).signOut(),
                child: Text(l10n.lockUsePassword),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
