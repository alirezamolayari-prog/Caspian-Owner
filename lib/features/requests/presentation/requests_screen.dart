import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/widgets/placeholder_body.dart';
import 'package:flutter/material.dart';

/// Requests tab. Filters and the list arrive in M6.
class RequestsScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).requestsTitle)),
      body: const PlaceholderBody(),
    );
  }
}
