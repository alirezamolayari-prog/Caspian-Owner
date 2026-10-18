import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/features/assistant/domain/assistant_message.dart';
import 'package:caspian_owner/features/chat/domain/chat_message.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/stock/domain/stock.dart';
import 'package:clock/clock.dart';

/// Situations the developer screen can switch between.
enum MockScenario {
  /// Realistic data, short latency.
  normal,

  /// No requests, no stock.
  empty,

  /// Every call takes several seconds.
  slowNetwork,

  /// Every call fails with a server error.
  serverError,

  /// No connection: every call fails as if the phone were offline
  /// (cached data and the pending queue take over).
  offline,

  /// Every decision is answered with `409`: another owner decided first.
  conflict,
}

/// An in-memory stand-in for the middle server. Mock repositories call it;
/// it applies the same rules the real server will (first decision wins,
/// idempotency keys, locked items hide their stock).
class MockBackend {
  new(
    MockFixtures fixtures, {
    this.scenario = MockScenario.normal,
    this.latency = const Duration(milliseconds: 350),
  }) : me = fixtures.me,
       owners = fixtures.owners,
       fixtures = fixtures,
       requests = [...fixtures.requests],
       stock = [...fixtures.stock],
       movements = [...fixtures.movements],
       chats = [...fixtures.chats],
       assistantHistory = [...fixtures.assistantHistory] {
    chats.addAll(_longChat());
  }

  /// A months-long chat on request 121, so paging and the jump to the
  /// newest message can be tried (fixture chats are short).
  List<ChatMessage> _longChat() {
    final request = requests.where((r) => r.id == 'r-121').firstOrNull;
    if (request == null) return const [];
    final start = request.createdAt.subtract(const Duration(days: 90));
    return [
      for (var i = 0; i < 60; i++)
        ChatMessage(
          id: 'm-long-$i',
          requestId: request.id,
          author: i.isEven
              ? ChatAuthor(
                  kind: ChatAuthorKind.staff,
                  nameFa: request.requester.nameFa,
                )
              : ChatAuthor(
                  kind: ChatAuthorKind.owner,
                  nameFa: me.nameFa,
                  isMe: true,
                ),
          text: _longChatTexts[i % _longChatTexts.length],
          sentAt: start.add(Duration(hours: 36 * i)),
        ),
    ];
  }

  static const _longChatTexts = [
    'کالا امروز به محل رسید.',
    'ممنون. لطفاً رسیدش را در اپ انبار ثبت کنید.',
    'برای هفته بعد هم همین مقدار لازم است.',
    'باشه، بعد از دیدن مصرف این هفته تأیید می‌کنم.',
    'یک قلم آسیب دیده بود؛ عکسش را برای مدیر انبار فرستادم.',
    'خوب است. جایگزینش را از قفسه بردارید.',
  ];

  final MockFixtures fixtures;
  MockScenario scenario;
  Duration latency;

  final Owner me;
  final List<Owner> owners;
  final List<GoodsRequest> requests;
  final List<StockItem> stock;
  final List<MockMovement> movements;
  final List<ChatMessage> chats;
  final List<AssistantMessage> assistantHistory;

  /// Results of already-applied idempotency keys.
  final Map<String, Object> _applied = {};
  int _sequence = 0;

  bool get isEmpty => scenario == MockScenario.empty;

  String nextId(String prefix) => '$prefix-mock-${++_sequence}';

  /// Runs [handler] like a network call: waits, then fails or answers
  /// according to the current [scenario].
  Future<T> call<T>(T Function() handler) async {
    final wait = scenario == MockScenario.slowNetwork
        ? const Duration(seconds: 4)
        : latency;
    if (wait > Duration.zero) await Future<void>.delayed(wait);
    if (scenario == MockScenario.offline) {
      throw const NetworkException('mock offline');
    }
    if (scenario == MockScenario.serverError) {
      throw const ServerException(
        code: 'internal',
        statusCode: 500,
        messageFa: 'خطای سرور. کمی بعد دوباره تلاش کنید.',
      );
    }
    return handler();
  }

  /// Returns the stored result for [key], or runs [apply] once and stores it.
  T idempotent<T extends Object>(String key, T Function() apply) =>
      (_applied[key] ??= apply()) as T;

  // ---------------------------------------------------------------- requests

  GoodsRequest requestById(String id) => requests.firstWhere(
    (r) => r.id == id,
    orElse: () => throw const NotFoundException(),
  );

  void replaceRequest(GoodsRequest updated) {
    final index = requests.indexWhere((r) => r.id == updated.id);
    requests[index] = updated;
  }

  /// Applies an owner decision with the server's rules.
  GoodsRequest decide(Decision decision) {
    final current = requestById(decision.requestId);
    if (decision.action == DecisionAction.returnForEdit) {
      return _returnForEdit(current, decision);
    }

    if (scenario == MockScenario.conflict && current.canDecide) {
      final winner = current.copyWith(
        status: decision.action == DecisionAction.approve
            ? RequestStatus.rejected
            : RequestStatus.approved,
        decidedBy: DecidedBy(
          kind: DeciderKind.owner,
          nameFa: owners.firstWhere((o) => o.id != me.id).nameFa,
        ),
        decidedAt: clock.now().subtract(const Duration(minutes: 1)),
      );
      replaceRequest(winner);
      throw AlreadyDecidedException(winner);
    }

    return idempotent(decision.idempotencyKey, () {
      if (!current.canDecide) throw AlreadyDecidedException(current);
      final decided = current.copyWith(
        status: decision.action == DecisionAction.approve
            ? RequestStatus.approved
            : RequestStatus.rejected,
        decidedBy: DecidedBy(kind: DeciderKind.owner, nameFa: me.nameFa),
        decidedAt: clock.now(),
        decisionReason: decision.reason,
      );
      replaceRequest(decided);
      return decided;
    });
  }

  /// Sends a rejected request back with suggested quantities. Server rules:
  /// only while it is still `rejected` (first owner wins, `409`); every
  /// suggested quantity is between 0 (drop the line) and what was asked;
  /// at least one line stays.
  GoodsRequest _returnForEdit(GoodsRequest current, Decision decision) {
    if (scenario == MockScenario.conflict && current.canReturnForEdit) {
      final winner = current.copyWith(
        status: RequestStatus.returned,
        returnedForEdit: ReturnedForEdit(
          by: DecidedBy(
            kind: DeciderKind.owner,
            nameFa: owners.firstWhere((o) => o.id != me.id).nameFa,
          ),
          at: clock.now().subtract(const Duration(minutes: 1)),
          lines: [for (final l in current.lines) _returned(l, l.qty)],
        ),
      );
      replaceRequest(winner);
      throw AlreadyDecidedException(winner);
    }
    return idempotent(decision.idempotencyKey, () {
      if (!current.canReturnForEdit) throw AlreadyDecidedException(current);
      final suggested = {
        for (final l in decision.lines ?? const <DecisionLine>[])
          l.itemCode: l.qty,
      };
      final lines = [
        for (final l in current.lines)
          _returned(l, suggested[l.itemCode] ?? l.qty),
      ];
      final valid =
          lines.every((l) => l.newQty >= 0 && l.newQty <= l.oldQty) &&
          lines.any((l) => !l.removed);
      if (!valid) {
        throw const ServerException(
          code: 'invalid_lines',
          statusCode: 422,
          messageFa: 'مقدارها معتبر نیستند.',
        );
      }
      final returned = current.copyWith(
        status: RequestStatus.returned,
        returnedForEdit: ReturnedForEdit(
          by: DecidedBy(kind: DeciderKind.owner, nameFa: me.nameFa),
          at: clock.now(),
          note: decision.note,
          lines: lines,
        ),
      );
      replaceRequest(returned);
      return returned;
    });
  }

  ReturnedLine _returned(RequestLine line, double newQty) => ReturnedLine(
    itemCode: line.itemCode,
    itemNameFa: line.itemNameFa,
    unitFa: line.unitFa,
    oldQty: line.qty,
    newQty: newQty,
  );

  /// Past issues to the same location + floor, newest first.
  List<LocationUsage> locationHistory(GoodsRequest request, {int limit = 10}) {
    final items = {for (final s in stock) s.code: s};
    final usages = [
      for (final m in movements)
        if (m.movement.kind == StockMovementKind.outgoing &&
            m.movement.place?.locationCode == request.place.locationCode &&
            m.movement.place?.floorCode == request.place.floorCode)
          LocationUsage(
            date: m.movement.date,
            itemNameFa: items[m.itemCode]?.nameFa ?? m.itemCode,
            qty: m.movement.qty,
            unitFa: items[m.itemCode]?.unitFa ?? '',
            documentNo: m.movement.documentNo,
          ),
    ]..sort((a, b) => b.date.compareTo(a.date));
    return usages.take(limit).toList();
  }

  // ------------------------------------------------------------ locked stock

  /// Items the Warehouse app is counting right now (its own stock counts):
  /// the server hides their quantity (`qty: null`, `locked_by_count`).
  /// Owners can't order counts any more (removed in v0.2.0).
  Set<String> get lockedItemCodes => {
    for (final s in stock)
      if (s.lockedByCount) s.code,
  };
  // -------------------------------------------------------------------- chat

  /// The chat about [requestId], oldest first.
  List<ChatMessage> chatFor(String requestId) => [
    for (final m in chats)
      if (m.requestId == requestId) m,
  ]..sort((a, b) => a.sentAt.compareTo(b.sentAt));

  ChatSummary chatSummary(String requestId) {
    final chat = chatFor(requestId);
    return ChatSummary(count: chat.length, last: chat.lastOrNull);
  }

  // --------------------------------------------------------------- assistant

  AssistantMessage answer(String question) {
    final now = clock.now();
    assistantHistory.add(
      AssistantMessage(
        id: nextId('a'),
        role: AssistantRole.user,
        text: question,
        at: now,
      ),
    );
    final match = fixtures.assistantAnswers.where(
      (a) => a.keywords.every(question.contains),
    );
    final reply = AssistantMessage(
      id: nextId('a'),
      role: AssistantRole.assistant,
      text: match.isEmpty ? fixtures.assistantFallback : match.first.text,
      at: now,
    );
    assistantHistory.add(reply);
    return reply;
  }
}
