import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderException;

/// The Persian message to show for [error]: the server's own message when
/// it sent one, otherwise a generic text.
String errorMessage(Object error, AppLocalizations l10n) {
  final cause = error is ProviderException ? error.exception : error;
  return switch (cause) {
    NetworkException() => l10n.errorNetwork,
    ServerException(messageFa: final String message) => message,
    ConflictException(messageFa: final String message) => message,
    _ => l10n.errorGeneric,
  };
}
