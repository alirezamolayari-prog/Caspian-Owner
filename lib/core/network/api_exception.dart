import 'package:caspian_owner/features/requests/domain/goods_request.dart';

/// Every failure a repository can report. Mock and API implementations
/// throw the same types, so the UI never knows which one it talks to.
sealed class ApiException implements Exception {
  const new();
}

/// No connection, or the server didn't answer in time. Decisions made
/// while offline go to the pending queue.
final class NetworkException extends ApiException {
  const new([this.detail]);

  final String? detail;

  @override
  String toString() => 'NetworkException(${detail ?? ''})';
}

/// The server answered with an error (contract: `Error`).
final class ServerException extends ApiException {
  const new({required this.code, this.messageFa, this.statusCode});

  final String code;
  final String? messageFa;
  final int? statusCode;

  @override
  String toString() => 'ServerException($statusCode $code)';
}

/// The session expired or was revoked; the owner must log in again.
final class UnauthorizedException extends ApiException {
  const new();
}

final class NotFoundException extends ApiException {
  const new();
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
