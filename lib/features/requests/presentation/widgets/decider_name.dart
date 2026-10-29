import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';

/// Who decided, as shown: «شما», «یکی از مالکان» (Caspian Server never
/// names the owner), an owner's name (mock data), or the warehouse manager.
String deciderName(DecidedBy by, AppLocalizations l10n) => switch (by.kind) {
  DeciderKind.me => l10n.decidedByYou,
  DeciderKind.anotherOwner => l10n.decidedByAnotherOwner,
  DeciderKind.manager => '${by.nameFa} (${l10n.managerLabel})',
  DeciderKind.owner => by.nameFa,
};
