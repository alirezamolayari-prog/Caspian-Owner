import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/mock/mock_fixtures.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/features/assistant/domain/assistant_message.dart';
import 'package:caspian_owner/features/chat/domain/chat_message.dart';
import 'package:caspian_owner/features/count/domain/surprise_count.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/stock/domain/stock.dart';
import 'package:clock/clock.dart';

/// Situations the developer screen can switch between.
enum MockScenario {
  /// Realistic data, short latency.
  normal,

  /// No requests, no stock, no counts.
  empty,

  /// Every call takes several seconds.
  slowNetwork,

  /// Every call fails with a server error.
  serverError,

  /// Every decision is answered with `409`: another owner decided first.
  conflict,
}

/// An in-memory stand-in for the middle server. Mock repositories call it;
/// it applies the same rules the real server will (first decision wins,
/// idempotency keys, counts hide stock).
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
       counts = [...fixtures.counts],
       assistantHistory = [...fixtures.assistantHistory];

  final MockFixtures fixtures;
  MockScenario scenario;
  Duration latency;

  final Owner me;
  final List<Owner> owners;
  final List<GoodsRequest> requests;
  final List<StockItem> stock;
  final List<MockMovement> movements;
  final List<ChatMessage> chats;
  final List<SurpriseCount> counts;
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

  // ------------------------------------------------------------------ counts

  Set<String> get lockedItemCodes => {
    for (final c in counts)
      if (c.status == CountStatus.running)
        for (final item in c.items) item.itemCode,
  };

  /// Stock as owners see it: quantities hidden while a count runs.
  List<StockItem> visibleStock() {
    final locked = lockedItemCodes;
    return [
      for (final item in stock)
        if (locked.contains(item.code))
          item.copyWith(qty: null, lockedByCount: true)
        else
          item.copyWith(lockedByCount: false),
    ];
  }

  SurpriseCount startCount(List<String> itemCodes, String idempotencyKey) =>
      idempotent(idempotencyKey, () {
        final locked = lockedItemCodes;
        if (itemCodes.any(locked.contains)) {
          throw const ConflictException(
            messageFa: 'بعضی از این اقلام همین الان در شمارش هستند.',
          );
        }
        final items = [
          for (final code in itemCodes)
            stock.firstWhere(
              (s) => s.code == code,
              orElse: () => throw const NotFoundException(),
            ),
        ];
        final count = SurpriseCount(
          id: nextId('c'),
          orderedBy: me,
          orderedAt: clock.now(),
          status: CountStatus.running,
          items: [
            for (final s in items)
              CountItem(
                itemCode: s.code,
                itemNameFa: s.nameFa,
                unitFa: s.unitFa,
              ),
          ],
        );
        counts.insert(0, count);
        return count;
      });

  /// Simulates staff finishing a running count (developer screen, tests).
  /// [counted] maps item codes to counted quantities; missing items are
  /// counted equal to the system quantity.
  SurpriseCount completeCount(
    String id, {
    Map<String, double> counted = const {},
    Person? countedBy,
  }) {
    final index = counts.indexWhere((c) => c.id == id);
    if (index < 0) throw const NotFoundException();
    final staff = countedBy ?? fixtures.persons.first;
    final now = clock.now();
    final done = counts[index].copyWith(
      status: CountStatus.done,
      finishedAt: now,
      results: [
        for (final item in counts[index].items)
          _result(item.itemCode, counted[item.itemCode], staff, now),
      ],
    );
    counts[index] = done;
    return done;
  }

  CountResult _result(
    String itemCode,
    double? counted,
    Person staff,
    DateTime now,
  ) {
    final system = stock.firstWhere((s) => s.code == itemCode).qty ?? 0;
    final qty = counted ?? system;
    return CountResult(
      itemCode: itemCode,
      systemQty: system,
      countedQty: qty,
      entries: [CountEntry(qty: qty, enteredBy: staff, enteredAt: now)],
      countedBy: [staff],
    );
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
