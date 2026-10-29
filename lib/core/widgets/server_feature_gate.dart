import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/widgets/module_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows [child], or a «به‌زودی» page when the server has no API for it yet
/// (stock, assistant, reports and the notification list on Caspian Server
/// v1). Owners never see sample numbers they might trust.
class ServerFeatureGate extends ConsumerWidget {
  const new({
    required this.title,
    required this.child,
    this.inModule = false,
    super.key,
  });

  final String Function(AppLocalizations l10n) title;
  final Widget child;

  /// A module tab (uses [ModuleAppBar]); otherwise a pushed screen.
  final bool inModule;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(serverCapabilitiesProvider).extraModules) return child;
    final l10n = AppLocalizations.of(context);
    final heading = Text(title(l10n));
    return Scaffold(
      appBar: inModule ? ModuleAppBar(title: heading) : AppBar(title: heading),
      body: const NotConnectedBody(),
    );
  }
}

/// «به‌زودی – این بخش هنوز به سرور کاسپین وصل نشده است…»: a calm empty
/// state (icon in a tinted circle, a title and one line), no sample data.
class NotConnectedBody extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Space.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Space.lg),
                    child: Icon(
                      AppIcons.offline,
                      size: 40,
                      color: scheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Space.lg),
              Text(
                l10n.notConnectedTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: Space.sm),
              Text(
                l10n.notConnectedBody,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
