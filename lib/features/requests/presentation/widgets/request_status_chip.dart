import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/widgets/status_chip.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:flutter/widgets.dart';

/// منتظر / تأیید شد / حواله صادر شد / رد شد / برگشت برای اصلاح / لغو شد /
/// نامشخص, always with an icon.
class RequestStatusChip extends StatelessWidget {
  const new(this.status, {super.key});

  final RequestStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (status) {
      RequestStatus.pending => StatusChip(
        label: l10n.statusPending,
        icon: AppIcons.pending,
        tone: StatusTone.warning,
      ),
      RequestStatus.approved => StatusChip(
        label: l10n.statusApproved,
        icon: AppIcons.approved,
        tone: StatusTone.success,
      ),
      RequestStatus.rejected => StatusChip(
        label: l10n.statusRejected,
        icon: AppIcons.rejected,
        tone: StatusTone.error,
      ),
      RequestStatus.returned => StatusChip(
        label: l10n.statusReturned,
        icon: AppIcons.returned,
      ),
      RequestStatus.cancelled => StatusChip(
        label: l10n.statusCancelled,
        icon: AppIcons.cancelled,
      ),
      RequestStatus.issued => StatusChip(
        label: l10n.statusIssued,
        icon: AppIcons.issued,
        tone: StatusTone.success,
      ),
      RequestStatus.unknown => StatusChip(
        label: l10n.statusUnknown,
        icon: AppIcons.unknown,
      ),
    };
  }
}
