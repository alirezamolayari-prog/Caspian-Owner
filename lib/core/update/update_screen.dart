import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/update/update_panel.dart';
import 'package:caspian_owner/core/widgets/safe_bottom.dart';
import 'package:flutter/material.dart';

/// This build is too old to keep using: download and install the update,
/// with no way back into the app. (Optional updates are installed from
/// «درباره و نسخه».)
class UpdateScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(l10n.updateRequiredTitle),
        ),
        body: ListView(
          padding: const EdgeInsets.all(Space.lg).withSafeBottom(context),
          children: [
            Text(l10n.updateRequiredBody, style: theme.textTheme.bodyLarge),
            const SizedBox(height: Space.lg),
            const UpdatePanel(blocking: true),
          ],
        ),
      ),
    );
  }
}
