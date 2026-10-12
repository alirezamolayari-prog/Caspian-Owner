import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/widgets/placeholder_body.dart';
import 'package:flutter/material.dart';

/// One request (pushed over the tabs). Content arrives in M6.
class RequestDetailScreen extends StatelessWidget {
  const new({required this.requestId, super.key});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).requestsTitle)),
      body: const PlaceholderBody(),
    );
  }
}
