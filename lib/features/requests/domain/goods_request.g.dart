// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DecidedBy _$DecidedByFromJson(Map<String, dynamic> json) => _DecidedBy(
  kind: $enumDecode(_$DeciderKindEnumMap, json['kind']),
  nameFa: json['name_fa'] as String,
);

Map<String, dynamic> _$DecidedByToJson(_DecidedBy instance) =>
    <String, dynamic>{
      'kind': _$DeciderKindEnumMap[instance.kind]!,
      'name_fa': instance.nameFa,
    };

const _$DeciderKindEnumMap = {
  DeciderKind.owner: 'owner',
  DeciderKind.manager: 'manager',
  DeciderKind.me: 'me',
  DeciderKind.anotherOwner: 'another_owner',
};

_RequestLine _$RequestLineFromJson(Map<String, dynamic> json) => _RequestLine(
  itemCode: json['item_code'] as String,
  itemNameFa: json['item_name_fa'] as String,
  qty: (json['qty'] as num).toDouble(),
  unitFa: json['unit_fa'] as String,
  stockNow: (json['stock_now'] as num?)?.toDouble(),
  usedLast30d: (json['used_last_30d'] as num).toDouble(),
);

Map<String, dynamic> _$RequestLineToJson(_RequestLine instance) =>
    <String, dynamic>{
      'item_code': instance.itemCode,
      'item_name_fa': instance.itemNameFa,
      'qty': instance.qty,
      'unit_fa': instance.unitFa,
      'stock_now': instance.stockNow,
      'used_last_30d': instance.usedLast30d,
    };

_LocationUsage _$LocationUsageFromJson(Map<String, dynamic> json) =>
    _LocationUsage(
      date: DateTime.parse(json['date'] as String),
      itemNameFa: json['item_name_fa'] as String,
      qty: (json['qty'] as num).toDouble(),
      unitFa: json['unit_fa'] as String,
      documentNo: json['document_no'] as String,
    );

Map<String, dynamic> _$LocationUsageToJson(_LocationUsage instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'item_name_fa': instance.itemNameFa,
      'qty': instance.qty,
      'unit_fa': instance.unitFa,
      'document_no': instance.documentNo,
    };

_ChatSummary _$ChatSummaryFromJson(Map<String, dynamic> json) => _ChatSummary(
  count: (json['count'] as num).toInt(),
  last: json['last'] == null
      ? null
      : ChatMessage.fromJson(json['last'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatSummaryToJson(_ChatSummary instance) =>
    <String, dynamic>{
      'count': instance.count,
      'last': ?instance.last?.toJson(),
    };

_ReturnedLine _$ReturnedLineFromJson(Map<String, dynamic> json) =>
    _ReturnedLine(
      itemCode: json['item_code'] as String,
      itemNameFa: json['item_name_fa'] as String,
      unitFa: json['unit_fa'] as String,
      oldQty: (json['old_qty'] as num).toDouble(),
      newQty: (json['new_qty'] as num).toDouble(),
    );

Map<String, dynamic> _$ReturnedLineToJson(_ReturnedLine instance) =>
    <String, dynamic>{
      'item_code': instance.itemCode,
      'item_name_fa': instance.itemNameFa,
      'unit_fa': instance.unitFa,
      'old_qty': instance.oldQty,
      'new_qty': instance.newQty,
    };

_ReturnedForEdit _$ReturnedForEditFromJson(Map<String, dynamic> json) =>
    _ReturnedForEdit(
      by: DecidedBy.fromJson(json['by'] as Map<String, dynamic>),
      at: DateTime.parse(json['at'] as String),
      lines: (json['lines'] as List<dynamic>)
          .map((e) => ReturnedLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$ReturnedForEditToJson(_ReturnedForEdit instance) =>
    <String, dynamic>{
      'by': instance.by.toJson(),
      'at': instance.at.toIso8601String(),
      'lines': instance.lines.map((e) => e.toJson()).toList(),
      'note': ?instance.note,
    };

_GoodsRequest _$GoodsRequestFromJson(Map<String, dynamic> json) =>
    _GoodsRequest(
      id: json['id'] as String,
      number: (json['number'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      requester: Person.fromJson(json['requester'] as Map<String, dynamic>),
      place: ConsumptionPlace.fromJson(json['place'] as Map<String, dynamic>),
      lines: (json['lines'] as List<dynamic>)
          .map((e) => RequestLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: $enumDecode(_$RequestStatusEnumMap, json['status']),
      escalated: json['escalated'] as bool,
      note: json['note'] as String?,
      escalationReason: $enumDecodeNullable(
        _$EscalationReasonEnumMap,
        json['escalation_reason'],
      ),
      decidedBy: json['decided_by'] == null
          ? null
          : DecidedBy.fromJson(json['decided_by'] as Map<String, dynamic>),
      decidedAt: json['decided_at'] == null
          ? null
          : DateTime.parse(json['decided_at'] as String),
      decisionReason: json['decision_reason'] as String?,
      issueNumber: json['issue_number'] as String?,
      issuedAt: json['issued_at'] == null
          ? null
          : DateTime.parse(json['issued_at'] as String),
      locationHistory: (json['location_history'] as List<dynamic>?)
          ?.map((e) => LocationUsage.fromJson(e as Map<String, dynamic>))
          .toList(),
      chatSummary: json['chat_summary'] == null
          ? null
          : ChatSummary.fromJson(json['chat_summary'] as Map<String, dynamic>),
      returnedForEdit: json['returned_for_edit'] == null
          ? null
          : ReturnedForEdit.fromJson(
              json['returned_for_edit'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$GoodsRequestToJson(
  _GoodsRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'created_at': instance.createdAt.toIso8601String(),
  'requester': instance.requester.toJson(),
  'place': instance.place.toJson(),
  'lines': instance.lines.map((e) => e.toJson()).toList(),
  'status': _$RequestStatusEnumMap[instance.status]!,
  'escalated': instance.escalated,
  'note': ?instance.note,
  'escalation_reason': ?_$EscalationReasonEnumMap[instance.escalationReason],
  'decided_by': ?instance.decidedBy?.toJson(),
  'decided_at': ?instance.decidedAt?.toIso8601String(),
  'decision_reason': ?instance.decisionReason,
  'issue_number': ?instance.issueNumber,
  'issued_at': ?instance.issuedAt?.toIso8601String(),
  'location_history': ?instance.locationHistory
      ?.map((e) => e.toJson())
      .toList(),
  'chat_summary': ?instance.chatSummary?.toJson(),
  'returned_for_edit': ?instance.returnedForEdit?.toJson(),
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.approved: 'approved',
  RequestStatus.rejected: 'rejected',
  RequestStatus.cancelled: 'cancelled',
  RequestStatus.returned: 'returned',
  RequestStatus.issued: 'issued',
  RequestStatus.unknown: 'unknown',
};

const _$EscalationReasonEnumMap = {
  EscalationReason.amount: 'amount',
  EscalationReason.quantity: 'quantity',
  EscalationReason.importantItem: 'important_item',
  EscalationReason.manual: 'manual',
};

_DecisionLine _$DecisionLineFromJson(Map<String, dynamic> json) =>
    _DecisionLine(
      itemCode: json['item_code'] as String,
      qty: (json['qty'] as num).toDouble(),
    );

Map<String, dynamic> _$DecisionLineToJson(_DecisionLine instance) =>
    <String, dynamic>{'item_code': instance.itemCode, 'qty': instance.qty};

_Decision _$DecisionFromJson(Map<String, dynamic> json) => _Decision(
  requestId: json['request_id'] as String,
  action: $enumDecode(_$DecisionActionEnumMap, json['action']),
  idempotencyKey: json['idempotency_key'] as String,
  reason: json['reason'] as String?,
  lines: (json['lines'] as List<dynamic>?)
      ?.map((e) => DecisionLine.fromJson(e as Map<String, dynamic>))
      .toList(),
  note: json['note'] as String?,
);

Map<String, dynamic> _$DecisionToJson(_Decision instance) => <String, dynamic>{
  'request_id': instance.requestId,
  'action': _$DecisionActionEnumMap[instance.action]!,
  'idempotency_key': instance.idempotencyKey,
  'reason': ?instance.reason,
  'lines': ?instance.lines?.map((e) => e.toJson()).toList(),
  'note': ?instance.note,
};

const _$DecisionActionEnumMap = {
  DecisionAction.approve: 'approve',
  DecisionAction.reject: 'reject',
  DecisionAction.returnForEdit: 'return_for_edit',
};
