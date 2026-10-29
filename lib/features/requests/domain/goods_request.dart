import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/domain/place.dart';
import 'package:caspian_owner/features/chat/domain/chat_message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'goods_request.freezed.dart';
part 'goods_request.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum RequestStatus {
  pending,
  approved,
  rejected,
  cancelled,

  /// A rejected request an owner sent back to the requester with suggested
  /// quantities («برگشت برای اصلاح»). The requester fixes and resubmits it in
  /// the Warehouse app (that is the server's and Warehouse app's part).
  returned,

  /// Approved, and the warehouse has issued the goods («حواله صادر شد»).
  issued,

  /// A status this app version doesn't know. Shown as «نامشخص», never
  /// decidable, never counted as waiting.
  unknown,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum EscalationReason { amount, quantity, importantItem, manual }

/// Who made a decision: an owner (in this app) or the warehouse manager
/// (in the Warehouse app, for routine requests). Caspian Server never says
/// which owner: only [me] or [anotherOwner], with no name.
@JsonEnum(fieldRename: FieldRename.snake)
enum DeciderKind { owner, manager, me, anotherOwner }

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

    /// Null while the Warehouse app counts the item.
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

/// The chat about a request at a glance (contract: `ChatSummary`), so the
/// detail screen can show a small «گفتگو» tile without loading the chat.
@freezed
abstract class ChatSummary with _$ChatSummary {
  const factory({required int count, ChatMessage? last}) = _ChatSummary;

  factory fromJson(Map<String, Object?> json) => _$ChatSummaryFromJson(json);
}

/// One line of a request sent back for changes: what was asked and what
/// the owner suggests. [newQty] 0 means the owner suggests dropping the
/// line (contract: `ReturnedLine`).
@freezed
abstract class ReturnedLine with _$ReturnedLine {
  const factory({
    required String itemCode,
    required String itemNameFa,
    required String unitFa,
    required double oldQty,
    required double newQty,
  }) = _ReturnedLine;

  const new _();

  factory fromJson(Map<String, Object?> json) => _$ReturnedLineFromJson(json);

  bool get removed => newQty == 0;
}

/// Who sent a rejected request back, when, and with which suggestions
/// (contract: `ReturnedForEdit`).
@freezed
abstract class ReturnedForEdit with _$ReturnedForEdit {
  const factory({
    required DecidedBy by,
    required DateTime at,
    required List<ReturnedLine> lines,
    String? note,
  }) = _ReturnedForEdit;

  factory fromJson(Map<String, Object?> json) =>
      _$ReturnedForEditFromJson(json);
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

    /// The warehouse's issue document («حواله»), once [RequestStatus.issued].
    String? issueNumber,
    DateTime? issuedAt,
    List<LocationUsage>? locationHistory,
    ChatSummary? chatSummary,
    ReturnedForEdit? returnedForEdit,
  }) = _GoodsRequest;

  const new _();

  factory fromJson(Map<String, Object?> json) => _$GoodsRequestFromJson(json);

  /// Owners may act only on escalated requests that are still pending.
  bool get canDecide => escalated && status == RequestStatus.pending;

  /// Approved (and maybe already issued) or rejected.
  bool get isDecided =>
      status == RequestStatus.approved ||
      status == RequestStatus.issued ||
      status == RequestStatus.rejected;

  /// Any rejected request can be sent back for changes (first one wins).
  bool get canReturnForEdit => status == RequestStatus.rejected;
}

@JsonEnum(fieldRename: FieldRename.snake)
enum DecisionAction {
  approve,
  reject,

  /// Send a rejected request back with suggested quantities (v0.2.0).
  returnForEdit,
}

/// A suggested quantity in a [DecisionAction.returnForEdit]
/// (contract: `DecisionLine`). 0 drops the line.
@freezed
abstract class DecisionLine with _$DecisionLine {
  const factory({required String itemCode, required double qty}) =
      _DecisionLine;

  factory fromJson(Map<String, Object?> json) => _$DecisionLineFromJson(json);
}

/// An owner's decision (contract: `Decision`).
@freezed
abstract class Decision with _$Decision {
  const factory({
    required String requestId,
    required DecisionAction action,

    /// Lets the server apply the same decision only once (offline retries).
    required String idempotencyKey,
    String? reason,

    /// Return for edit only: every line with its suggested quantity.
    List<DecisionLine>? lines,

    /// Return for edit only: a note for the requester.
    String? note,
  }) = _Decision;

  factory fromJson(Map<String, Object?> json) => _$DecisionFromJson(json);
}
