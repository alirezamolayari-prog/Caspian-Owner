import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/widgets/placeholder_body.dart';
import 'package:flutter/material.dart';

/// Start a surprise count: pick items, confirm. Built in M8.
class CountStartScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).countCardTitle)),
      body: const PlaceholderBody(),
    );
  }
}
