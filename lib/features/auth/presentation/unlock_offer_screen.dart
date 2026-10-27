import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/core/security/device_authenticator.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/features/auth/presentation/widgets/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Right after a password login: «ورود سریع با اثر انگشت؟». Yes asks for
/// one touch; «فعلاً نه» leads to creating a 4-digit app PIN. Either way
/// the server password stays as it is.
class UnlockOfferScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<UnlockOfferScreen> createState() => _UnlockOfferScreenState();
}

class _UnlockOfferScreenState extends ConsumerState<UnlockOfferScreen> {
  bool _busy = false;
  String? _error;

  Future<void> _enable() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await ref
        .read(appLockControllerProvider.notifier)
        .enableDeviceUnlock(AuthPrompt.of(l10n, l10n.unlockOfferReason));
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (!ok) _error = l10n.unlockOfferFailed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AuthPage(
      showBack: false,
      icon: AppIcons.fingerprint,
      title: l10n.unlockOfferTitle,
      body: l10n.unlockOfferBody,
      children: [
        if (_error case final error?) ...[
          FormMessage(error),
          const SizedBox(height: Space.md),
        ],
        BigButton(
          label: l10n.unlockOfferYes,
          icon: AppIcons.fingerprint,
          busy: _busy,
          onPressed: _enable,
        ),
        const SizedBox(height: Space.md),
        SecondButton(
          label: l10n.unlockOfferNo,
          onPressed: _busy
              ? null
              : () => ref
                    .read(appLockControllerProvider.notifier)
                    .declineDeviceUnlock(),
        ),
        const SizedBox(height: Space.sm),
        Text(
          l10n.unlockOfferNoNote,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
