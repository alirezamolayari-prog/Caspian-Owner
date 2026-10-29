import 'dart:async';

import 'package:caspian_owner/core/brand/brand.dart';
import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/update/update_controller.dart';
import 'package:caspian_owner/core/update/update_manifest.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/widgets/safe_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «درباره و نسخه». Tapping the version 7 times opens the developer screen.
class AboutScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  static const _tapsToUnlock = 7;
  int _taps = 0;

  /// The check can take a while on a slow network (both manifest URLs).
  bool _checking = false;

  void _onVersionTap() {
    _taps++;
    if (_taps < _tapsToUnlock) return;
    _taps = 0;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).devUnlocked)),
    );
    unawaited(context.push(Routes.developer));
  }

  Future<void> _checkForUpdate() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _checking = true);
    final UpdateManifest? manifest;
    try {
      manifest = await ref
          .read(updateControllerProvider.notifier)
          .check(force: true);
    } finally {
      if (mounted) setState(() => _checking = false);
    }
    if (!mounted) return;
    final update = ref.read(updateControllerProvider);
    if (update.decision is NoUpdate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            manifest == null ? l10n.aboutUpdateCheckFailed : l10n.aboutUpToDate,
          ),
        ),
      );
    } else if (!update.required) {
      unawaited(context.push(Routes.update));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final info = ref.watch(appInfoProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreAbout)),
      body: ListView(
        padding: const EdgeInsets.all(Space.lg).withSafeBottom(context),
        children: [
          Text(Brand.appNameFa, style: theme.textTheme.headlineSmall),
          Text(
            l10n.aboutMall(Brand.mallNameFa),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: Space.lg),
          // Tap target for the hidden developer screen.
          InkWell(
            onTap: _onVersionTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.md),
              child: Text(
                l10n.aboutVersion(
                  toPersianDigits(info.version),
                  toPersianDigits('${info.buildNumber}'),
                ),
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: _checking ? null : _checkForUpdate,
            icon: _checking
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
            label: Text(
              _checking ? l10n.aboutCheckingUpdate : l10n.aboutCheckUpdate,
            ),
          ),
          const SizedBox(height: Space.md),
          Text(Brand.supportContactFa, style: theme.textTheme.bodyMedium),
          const SizedBox(height: Space.lg),
          // The copyright line stays in English, as in LICENSE.
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(Brand.copyrightLine, style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
