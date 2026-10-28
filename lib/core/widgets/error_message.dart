import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderException;

/// The Persian message to show for [error]. Server errors get the app's own
/// texts (one wording everywhere); messages the server writes for owners
/// (account errors, `detail`) and the mock's are shown as sent.
///
/// [atLogin]: a `401` there means a wrong password, not an expired session.
String errorMessage(
  Object error,
  AppLocalizations l10n, {
  bool atLogin = false,
}) {
  final cause = error is ProviderException ? error.exception : error;
  return switch (cause) {
    NetworkException(offline: true) => l10n.errorOffline,
    NetworkException() => l10n.errorNetwork,
    UnauthorizedException() when atLogin => l10n.errorWrongPassword,
    ServerException(code: 'invalid_credentials') => l10n.errorWrongPassword,
    UnauthorizedException() => l10n.errorSessionExpired,
    ForbiddenException() => l10n.errorForbidden,
    NotFoundException() => l10n.errorNotFound,
    AlreadyDecidedException() => l10n.errorConflict,
    ConflictException(messageFa: final String message) => message,
    ConflictException() => l10n.errorConflict,
    ValidationException(:final fieldErrors) when fieldErrors.isNotEmpty =>
      fieldErrors.values.first,
    ValidationException() => l10n.errorInvalidData,
    ServerException(code: 'not_owner') => l10n.errorNotOwner,
    ServerException(code: 'not_connected') => l10n.errorNotConnected,
    ServerException(code: 'mobile_taken') => l10n.errorMobileTaken,
    ServerException(code: 'account_not_found') => l10n.errorAccountNotFound,
    ServerException(code: 'sms_not_sent') => l10n.errorSmsNotSent,
    ServerException(messageFa: final String message) => message,
    ServerException(statusCode: 429) => l10n.errorTooManyRequests,
    ServerException() => l10n.errorServer,
    _ => l10n.errorGeneric,
  };
}
