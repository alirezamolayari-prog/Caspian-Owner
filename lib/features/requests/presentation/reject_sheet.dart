import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Asks for an optional reason. Returns the reason ('' when left empty) on
/// «رد کردن», or null on cancel.
Future<String?> showRejectSheet(
  BuildContext context, {
  required String number,
}) {
  // Close the keyboard first, or focus (and the keyboard) comes back to the
  // field under the sheet when it closes.
  FocusManager.instance.primaryFocus?.unfocus();
  return showModalBottomSheet<String>(
    context: context,
    // Above the bottom tabs, so the sheet is never cut off.
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (context) => _RejectSheet(number: number),
  );
}

class _RejectSheet extends StatefulWidget {
  const new({required this.number});

  final String number;

  @override
  State<_RejectSheet> createState() => _RejectSheetState();
}

class _RejectSheetState extends State<_RejectSheet> {
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final error = theme.colorScheme.error;

    return Padding(
      // Keep the field above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.rejectSheetTitle(widget.number),
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: Space.md),
              TextField(
                controller: _reason,
                autofocus: true,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: l10n.rejectReasonLabel,
                  hintText: l10n.rejectReasonHint,
                ),
              ),
              const SizedBox(height: Space.lg),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: error,
                        foregroundColor: theme.colorScheme.onError,
                      ),
                      onPressed: () =>
                          Navigator.pop(context, _reason.text.trim()),
                      child: Text(l10n.reject),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
