import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/domain/place.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'goods_request.freezed.dart';
part 'goods_request.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum RequestStatus { pending, approved, rejected, cancelled }

@JsonEnum(fieldRename: FieldRename.snake)
enum EscalationReason { amount, quantity, importantItem, manual }

/// Who made a decision: an owner (in this app) or the warehouse manager
/// (in the Warehouse app, for routine requests).
@JsonEnum(fieldRename: FieldRename.snake)
enum DeciderKind { owner, manager }

@freezed
abstract class DecidedBy with _$DecidedBy {
  const factory({required DeciderKind kind, required String nameFa}) =
      _DecidedBy;

  factory fromJson(Map<String, Object?> json) => _$DecidedByFromJson(json);
}

/// One item in a request (contract: `RequestLine`).
@freezed
abstract class RequestLine with _$RequestLine {
  const factory({
    required String itemCode,
    required String itemNameFa,
    required double qty,
    required String unitFa,

    /// Null while the item is hidden by a running surprise count.
    @JsonKey(includeIfNull: true) required double? stockNow,
    // Snake-case renaming would give `used_last30d`.
    @JsonKey(name: 'used_last_30d') required double usedLast30d,
  }) = _RequestLine;

  factory fromJson(Map<String, Object?> json) => _$RequestLineFromJson(json);
}

/// A past issue to the same place (contract: `LocationUsage`).
@freezed
abstract class LocationUsage with _$LocationUsage {
  const factory({
    required DateTime date,
    required String itemNameFa,
    required double qty,
    required String unitFa,
    required String documentNo,
  }) = _LocationUsage;

  factory fromJson(Map<String, Object?> json) => _$LocationUsageFromJson(json);
}

/// A goods request (درخواست کالا) from the Warehouse app
/// (contract: `GoodsRequest`).
@freezed
abstract class GoodsRequest with _$GoodsRequest {
  const factory({
    required String id,
    required int number,
    required DateTime createdAt,
    required Person requester,
    required ConsumptionPlace place,
    required List<RequestLine> lines,
    required RequestStatus status,

    /// True when owners must decide. Routine requests are decided by the
    /// warehouse manager and are shown read-only.
    required bool escalated,
    String? note,
    EscalationReason? escalationReason,
    DecidedBy? decidedBy,
    DateTime? decidedAt,
    String? decisionReason,
    List<LocationUsage>? locationHistory,
  }) = _GoodsRequest;

  const new _();

  factory fromJson(Map<String, Object?> json) => _$GoodsRequestFromJson(json);

  /// Owners may act only on escalated requests that are still pending.
  bool get canDecide => escalated && status == RequestStatus.pending;

  bool get isDecided =>
      status == RequestStatus.approved || status == RequestStatus.rejected;
}

@JsonEnum(fieldRename: FieldRename.snake)
enum DecisionAction { approve, reject }

/// An owner's decision (contract: `Decision`).
@freezed
abstract class Decision with _$Decision {
  const factory({
    required String requestId,
    required DecisionAction action,

    /// Lets the server apply the same decision only once (offline retries).
    required String idempotencyKey,
    String? reason,
  }) = _Decision;

  factory fromJson(Map<String, Object?> json) => _$DecisionFromJson(json);
}
