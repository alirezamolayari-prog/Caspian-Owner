import 'package:caspian_owner/features/requests/domain/goods_request.dart';

/// Every failure a repository can report. Mock and API implementations
/// throw the same types, so the UI never knows which one it talks to.
sealed class ApiException implements Exception {
  const new();
}

/// No connection, or the server didn't answer in time. Decisions made
/// while offline go to the pending queue.
final class NetworkException extends ApiException {
  const new([this.detail]) : offline = false;

  /// The phone has no internet (see [offline]).
  const new noInternet([this.detail]) : offline = true;

  final String? detail;

  /// The phone seems to have no internet at all (the server's name could
  /// not even be looked up), rather than the server not answering.
  final bool offline;

  @override
  String toString() => 'NetworkException(${detail ?? ''})';
}

/// The server answered with an error (contract: `Error`). Account
/// endpoints send their stable [code] in the `X-Error-Code` header and a
/// ready Persian [messageFa] in `detail` (docs: owner-auth-api.md).
final class ServerException extends ApiException {
  const new({
    required this.code,
    this.messageFa,
    this.statusCode,
    this.retryAfter,
  });

  final String code;
  final String? messageFa;
  final int? statusCode;

  /// From `Retry-After` on `429`: how long to wait before trying again.
  final Duration? retryAfter;

  @override
  String toString() => 'ServerException($statusCode $code)';
}

/// `401`: wrong username/password at login, or the session expired or was
/// revoked (the owner must log in again).
final class UnauthorizedException extends ApiException {
  const new();
}

/// `403`: logged in, but this account may not do that.
final class ForbiddenException extends ApiException {
  const new();
}

final class NotFoundException extends ApiException {
  const new();
}

/// `422`: the server refused the data (empty reason, too long text, …).
final class ValidationException extends ApiException {
  const new({this.fieldErrors = const {}});

  /// Field name → the server's Persian message, from FastAPI's list form
  /// (`detail[].loc[1]`, without its «Value error, » prefix).
  final Map<String, String> fieldErrors;
}

/// `409` on a decision: another owner (or the warehouse manager) decided
/// first. [request] carries the winning decision.
final class AlreadyDecidedException extends ApiException {
  const new(this.request);

  final GoodsRequest request;

  @override
  String toString() => 'AlreadyDecidedException(${request.id})';
}

/// Another `409`, e.g. items already in a running count.
final class ConflictException extends ApiException {
  const new({this.messageFa});

  final String? messageFa;
}
