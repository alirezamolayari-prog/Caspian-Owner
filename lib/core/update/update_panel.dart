import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/update/update_controller.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The new version (number, size, what's new) and «دانلود و نصب» with its
/// progress, the install permission help and errors. Shown in «درباره و
/// نسخه» and on the blocking «update required» screen.
class UpdatePanel extends ConsumerWidget {
  const new({this.blocking = false, super.key});

  /// The blocking screen: no «you can leave this page» hint.
  final bool blocking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final update = ref.watch(updateControllerProvider);
    final controller = ref.read(updateControllerProvider.notifier);
    final manifest = update.manifest;
    if (manifest == null) return const SizedBox.shrink();
    final progress = update.progress;
    final ready = update.readyApk != null && !update.downloading;
    final error = switch (update.problem) {
      UpdateProblem.downloadFailed => l10n.updateDownloadFailed,
      UpdateProblem.checksumFailed => l10n.updateChecksumFailed,
      UpdateProblem.installFailed => l10n.updateInstallFailed,
      UpdateProblem.needsPermission || null => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.updateVersion(toPersianDigits(manifest.version)),
          style: theme.textTheme.titleLarge,
        ),
        Text(
          l10n.updateSize(
            formatNumber(
              (manifest.sizeBytes / (1024 * 1024) * 10).round() / 10,
            ),
          ),
          style: theme.textTheme.bodySmall,
        ),
        if (manifest.changelogFa.isNotEmpty) ...[
          const SizedBox(height: Space.md),
          Text(manifest.changelogFa, style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: Space.lg),
        if (update.problem == UpdateProblem.needsPermission) ...[
          Text(l10n.updatePermissionTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: Space.sm),
          Text(l10n.updatePermissionBody, style: theme.textTheme.bodyMedium),
          const SizedBox(height: Space.md),
          OutlinedButton(
            onPressed: controller.openInstallPermission,
            child: Text(l10n.updateOpenSettings),
          ),
          const SizedBox(height: Space.md),
        ],
        if (error != null) ...[
          Semantics(
            liveRegion: true,
            child: Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          const SizedBox(height: Space.md),
        ],
        if (update.downloading) ...[
          LinearProgressIndicator(value: progress),
          const SizedBox(height: Space.sm),
          Semantics(
            liveRegion: true,
            child: Text(
              progress == null
                  ? l10n.updateDownloadingStarted
                  : l10n.updateDownloading((progress * 100).round()),
              style: theme.textTheme.bodyMedium,
            ),
          ),
          if (!blocking) ...[
            const SizedBox(height: Space.sm),
            Text(
              l10n.updateLeaveHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: Space.md),
        ],
        if (ready && update.problem == null) ...[
          Text(l10n.updateReadyHint, style: theme.textTheme.bodyMedium),
          const SizedBox(height: Space.md),
        ],
        FilledButton(
          onPressed: update.downloading ? null : controller.downloadAndInstall,
          child: Text(ready ? l10n.updateInstall : l10n.updateDownloadInstall),
        ),
      ],
    );
  }
}
