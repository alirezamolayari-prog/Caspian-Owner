import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/widgets/placeholder_body.dart';
import 'package:flutter/material.dart';

/// Stock tab. Search, filters and the list arrive in M7.
class StockScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).stockTitle)),
      body: const PlaceholderBody(),
    );
  }
}
