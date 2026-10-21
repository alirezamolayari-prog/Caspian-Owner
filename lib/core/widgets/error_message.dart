import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderException;

/// The Persian message to show for [error]. Server errors get the app's own
/// texts (one wording everywhere); the mock's messages are shown as sent.
///
/// [atLogin]: a `401` there means a wrong password, not an expired session.
String errorMessage(
  Object error,
  AppLocalizations l10n, {
  bool atLogin = false,
}) {
  final cause = error is ProviderException ? error.exception : error;
  return switch (cause) {
    NetworkException() => l10n.errorNetwork,
    UnauthorizedException() when atLogin => l10n.errorWrongPassword,
    UnauthorizedException() => l10n.errorSessionExpired,
    ForbiddenException() => l10n.errorForbidden,
    NotFoundException() => l10n.errorNotFound,
    AlreadyDecidedException() => l10n.errorConflict,
    ConflictException(messageFa: final String message) => message,
    ConflictException() => l10n.errorConflict,
    ValidationException() => l10n.errorInvalidData,
    ServerException(code: 'not_owner') => l10n.errorNotOwner,
    ServerException(code: 'not_connected') => l10n.errorNotConnected,
    ServerException(messageFa: final String message) => message,
    ServerException() => l10n.errorServer,
    _ => l10n.errorGeneric,
  };
}
