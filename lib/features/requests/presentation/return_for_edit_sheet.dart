import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:flutter/material.dart';

/// What the owner suggests: every line's quantity (0 = drop it) and a note.
class ReturnForEditResult {
  const new({required this.lines, this.note});

  final List<DecisionLine> lines;
  final String? note;
}

/// «ویرایش و برگرداندن»: suggest smaller quantities for a rejected request
/// (from 1 up to what was asked, or drop a line while another stays) and
/// add a note. Returns null on «انصراف».
Future<ReturnForEditResult?> showReturnForEditSheet(
  BuildContext context, {
  required GoodsRequest request,
}) {
  // Close the keyboard first, or focus comes back to the field under the
  // sheet when it closes.
  FocusManager.instance.primaryFocus?.unfocus();
  return showModalBottomSheet<ReturnForEditResult>(
    context: context,
    // Above the bottom tabs, so the sheet is never cut off.
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (context) => _ReturnForEditSheet(request: request),
  );
}

class _ReturnForEditSheet extends StatefulWidget {
  const new({required this.request});

  final GoodsRequest request;

  @override
  State<_ReturnForEditSheet> createState() => _ReturnForEditSheetState();
}

class _ReturnForEditSheetState extends State<_ReturnForEditSheet> {
  late final Map<String, double> _qty = {
    for (final l in widget.request.lines) l.itemCode: l.qty,
  };
  final _note = TextEditingController();

  int get _kept => _qty.values.where((q) => q > 0).length;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _set(String code, double value) => setState(() => _qty[code] = value);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final number = toPersianDigits('${widget.request.number}');

    return Padding(
      // Keep the note above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.returnSheetTitle(number),
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: Space.xs),
              Text(l10n.returnSheetHelp, style: theme.textTheme.bodySmall),
              const SizedBox(height: Space.md),
              for (final line in widget.request.lines)
                _LineEditor(
                  line: line,
                  qty: _qty[line.itemCode]!,
                  canRemove: _kept > 1,
                  onChanged: (v) => _set(line.itemCode, v),
                ),
              const SizedBox(height: Space.sm),
              TextField(
                controller: _note,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: l10n.returnNoteLabel,
                  hintText: l10n.returnNoteHint,
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
                      onPressed: () => Navigator.pop(
                        context,
                        ReturnForEditResult(
                          lines: [
                            for (final MapEntry(:key, :value) in _qty.entries)
                              DecisionLine(itemCode: key, qty: value),
                          ],
                          note: _note.text.trim().isEmpty
                              ? null
                              : _note.text.trim(),
                        ),
                      ),
                      child: Text(l10n.returnSend),
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

/// One line: name, «درخواستی: ۲۴ عدد», and − qty + (or «حذف شد» with a way
/// back).
class _LineEditor extends StatelessWidget {
  const new({
    required this.line,
    required this.qty,
    required this.canRemove,
    required this.onChanged,
  });

  final RequestLine line;
  final double qty;
  final bool canRemove;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final removed = qty == 0;
    final name = line.itemNameFa;

    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: theme.textTheme.titleSmall),
          Text(
            l10n.returnRequested(formatNumber(line.qty), line.unitFa),
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: Space.xs),
          if (removed)
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.returnLineRemoved,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => onChanged(line.qty),
                  child: Text(l10n.returnLineRestore),
                ),
              ],
            )
          else
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: Space.sm,
              runSpacing: Space.xs,
              children: [
                IconButton.outlined(
                  tooltip: l10n.returnLess(name),
                  icon: const Icon(AppIcons.remove),
                  onPressed: qty > 1 ? () => onChanged(qty - 1) : null,
                ),
                Semantics(
                  liveRegion: true,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 72),
                    child: Text(
                      l10n.qtyWithUnit(formatNumber(qty), line.unitFa),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ),
                IconButton.outlined(
                  tooltip: l10n.returnMore(name),
                  icon: const Icon(AppIcons.add),
                  // Never more than was asked.
                  onPressed: qty < line.qty
                      ? () => onChanged((qty + 1).clamp(1, line.qty))
                      : null,
                ),
                if (canRemove)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                    onPressed: () => onChanged(0),
                    icon: const Icon(AppIcons.delete),
                    label: Text(l10n.returnLineRemove),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
