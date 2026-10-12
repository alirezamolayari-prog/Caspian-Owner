import 'package:caspian_owner/core/brand/brand.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Home tab. Content (hero card, latest requests, surprise count) is M5.
class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final auth = ref.watch(authControllerProvider);
    final name = auth is SignedIn ? auth.session.owner.nameFa : '';

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: Space.page,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.homeGreeting(name), style: text.bodySmall),
            Text(Brand.shortNameFa, style: text.headlineMedium),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.notificationsTooltip,
            icon: const Icon(AppIcons.notifications),
            onPressed: () {},
          ),
          IconButton(
            tooltip: l10n.accountTooltip,
            icon: const Icon(AppIcons.account),
            onPressed: () => context.push(Routes.more),
          ),
          const SizedBox(width: Space.sm),
        ],
      ),
      body: const SizedBox.expand(),
    );
  }
}
