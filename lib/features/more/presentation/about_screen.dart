import 'dart:async';

import 'package:caspian_owner/core/brand/brand.dart';
import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
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

  void _onVersionTap() {
    _taps++;
    if (_taps < _tapsToUnlock) return;
    _taps = 0;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).devUnlocked)),
    );
    unawaited(context.push(Routes.developer));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final info = ref.watch(appInfoProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreAbout)),
      body: ListView(
        padding: const EdgeInsets.all(Space.lg),
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
          const SizedBox(height: Space.sm),
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
