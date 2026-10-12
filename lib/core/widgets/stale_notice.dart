import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_colors.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/relative_time.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

/// «آخرین به‌روزرسانی: ۱۰ دقیقه پیش» above data shown from the cache.
class StaleNotice extends StatelessWidget {
  const new({required this.cachedAt, super.key});

  final DateTime cachedAt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final when = formatRelativeTime(cachedAt, now: clock.now(), l10n: l10n);

    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.warningContainer,
          borderRadius: const BorderRadius.all(Radius.circular(Radii.chip)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Space.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(AppIcons.offline, color: colors.warning),
              const SizedBox(width: Space.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.lastUpdated(when),
                      style: text.titleSmall?.copyWith(color: colors.warning),
                    ),
                    Text(
                      l10n.offlineShowingCached,
                      style: text.bodySmall?.copyWith(color: colors.warning),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
