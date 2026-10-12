import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';

/// «لامپ LED ۱۸ وات · ۲۴ عدد», plus «و ۱ قلم دیگر» for more lines.
String requestTitle(GoodsRequest request, AppLocalizations l10n) {
  final first = request.lines.first;
  final title = l10n.requestLineTitle(
    first.itemNameFa,
    formatNumber(first.qty),
    first.unitFa,
  );
  final more = request.lines.length - 1;
  return more > 0 ? '$title ${l10n.requestMoreItems(more)}' : title;
}
