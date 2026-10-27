import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/features/auth/presentation/widgets/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A flow step opened without its earlier steps (e.g. Android restarted
/// the app): nothing to continue, start over.
class FlowExpired extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AuthPage(
      icon: AppIcons.pending,
      title: l10n.flowExpiredTitle,
      body: l10n.flowExpired,
      onBack: () => context.go(Routes.login),
      children: [
        BigButton(
          label: l10n.backToLogin,
          onPressed: () => context.go(Routes.login),
        ),
      ],
    );
  }
}
