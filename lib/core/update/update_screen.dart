import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/update/update_controller.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/core/widgets/safe_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Download and install an update. With [blocking] (this build is too old)
/// there is no way back into the app.
class UpdateScreen extends ConsumerWidget {
  const new({this.blocking = false, super.key});

  final bool blocking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final update = ref.watch(updateControllerProvider);
    final controller = ref.read(updateControllerProvider.notifier);
    final manifest = update.manifest;
    final progress = update.progress;
    final busy = progress != null && update.problem == null;

    return PopScope(
      canPop: !blocking,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: !blocking,
          title: Text(
            blocking ? l10n.updateRequiredTitle : l10n.updateAvailableTitle,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(Space.lg).withSafeBottom(context),
          children: [
            if (blocking) ...[
              Text(l10n.updateRequiredBody, style: theme.textTheme.bodyLarge),
              const SizedBox(height: Space.lg),
            ],
            if (manifest != null) ...[
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
              const SizedBox(height: Space.md),
              Text(manifest.changelogFa, style: theme.textTheme.bodyMedium),
              const SizedBox(height: Space.lg),
            ],
            if (update.problem == UpdateProblem.needsPermission) ...[
              Text(
                l10n.updatePermissionTitle,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: Space.sm),
              Text(
                l10n.updatePermissionBody,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: Space.md),
              OutlinedButton(
                onPressed: controller.openInstallPermission,
                child: Text(l10n.updateOpenSettings),
              ),
              const SizedBox(height: Space.md),
            ],
            if (update.problem
                case UpdateProblem.downloadFailed ||
                    UpdateProblem.checksumFailed) ...[
              Semantics(
                liveRegion: true,
                child: Text(
                  update.problem == UpdateProblem.checksumFailed
                      ? l10n.updateChecksumFailed
                      : l10n.updateDownloadFailed,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
              const SizedBox(height: Space.md),
            ],
            if (busy) ...[
              LinearProgressIndicator(value: progress),
              const SizedBox(height: Space.sm),
              Text(
                l10n.updateDownloading((progress * 100).round()),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: Space.md),
            ],
            FilledButton(
              onPressed: busy || manifest == null
                  ? null
                  : controller.downloadAndInstall,
              child: Text(l10n.updateDownloadInstall),
            ),
          ],
        ),
      ),
    );
  }
}
