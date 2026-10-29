import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Asks for the reason, which Caspian Server requires (an empty one is
/// refused with 422). Returns it on «رد کردن», or null on cancel.
Future<String?> showRejectSheet(
  BuildContext context, {
  required String number,
}) async {
  // Close the keyboard first, or focus (and the keyboard) comes back to the
  // field under the sheet when it closes.
  FocusManager.instance.primaryFocus?.unfocus();
  final reason = await showModalBottomSheet<String>(
    context: context,
    // Above the bottom tabs, so the sheet is never cut off.
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (context) => _RejectSheet(number: number),
  );
  // And once more after: no keyboard (or its toolbar) left over the
  // approve / reject buttons.
  FocusManager.instance.primaryFocus?.unfocus();
  await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
  return reason;
}

/// At least this many letters (not counting spaces) in a reason.
const minRejectReasonLength = 3;

bool isRejectReasonValid(String reason) =>
    reason.replaceAll(RegExp(r'\s'), '').characters.length >=
    minRejectReasonLength;

class _RejectSheet extends StatefulWidget {
  const new({required this.number});

  final String number;

  @override
  State<_RejectSheet> createState() => _RejectSheetState();
}

class _RejectSheetState extends State<_RejectSheet> {
  final _reason = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Redraws the button as the reason becomes long enough.
    _reason.addListener(() => setState(() {}));
  }

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
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: l10n.rejectReasonLabel,
                  hintText: l10n.rejectReasonHint,
                  helperText: l10n.rejectReasonHelper,
                  helperMaxLines: 2,
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
                      onPressed: isRejectReasonValid(_reason.text)
                          ? () => Navigator.pop(context, _reason.text.trim())
                          : null,
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
