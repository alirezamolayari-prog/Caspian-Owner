import 'package:caspian_owner/core/network/server_mappers.dart';
import 'package:caspian_owner/features/chat/domain/chat_message.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';
import 'package:caspian_owner/features/requests/presentation/requests_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_server.dart';

void main() {
  group('request status', () {
    for (final (server, app) in [
      ('pending', RequestStatus.pending),
      ('approved', RequestStatus.approved),
      ('rejected', RequestStatus.rejected),
      ('issued', RequestStatus.issued),
    ]) {
      test('$server → $app', () {
        expect(
          ServerMappers.request(serverRequest(status: server)).status,
          app,
        );
      });
    }

    test('an unknown status is «نامشخص», logged, and never decidable', () {
      final warnings = <String>[];
      ServerMappers.warn = warnings.add;
      addTearDown(() => ServerMappers.warn = null);

      final request = ServerMappers.request(serverRequest(status: 'archived'));

      expect(request.status, RequestStatus.unknown);
      expect(request.canDecide, isFalse);
      expect(warnings.single, contains('archived'));
    });

    test('issued keeps the issue number and counts as decided', () {
      final request = ServerMappers.request(
        serverRequest(status: 'issued', decidedByMe: false, issueNumber: 'H-7'),
      );
      expect(request.issueNumber, 'H-7');
      expect(request.issuedAt, isNotNull);
      expect(request.isDecided, isTrue);
      expect(request.canDecide, isFalse);
    });
  });

  test('only pending requests wait for an owner (home, hub, «منتظر» tab)', () {
    final requests = [
      for (final status in ['pending', 'approved', 'rejected', 'issued', 'x'])
        ServerMappers.request(serverRequest(status: status)),
    ];
    // Home «منتظر تأیید شما» and the hub badge count `canDecide`.
    expect(requests.where((r) => r.canDecide).length, 1);
    expect(
      requests.where((r) => matchesFilter(r, RequestFilter.pending)).length,
      1,
    );
    expect(
      [
        for (final r in requests)
          if (matchesFilter(r, RequestFilter.reviewed)) r.status,
      ],
      [RequestStatus.approved, RequestStatus.rejected, RequestStatus.issued],
    );
  });

  group('who decided (never a name)', () {
    test('me → DeciderKind.me', () {
      final r = ServerMappers.request(
        serverRequest(status: 'approved', decidedByMe: true),
      );
      expect(r.decidedBy?.kind, DeciderKind.me);
      expect(r.decidedBy?.nameFa, isEmpty);
    });

    test('someone else → another owner', () {
      final r = ServerMappers.request(
        serverRequest(status: 'rejected', decidedByMe: false),
      );
      expect(r.decidedBy?.kind, DeciderKind.anotherOwner);
    });

    test('pending: nobody', () {
      expect(ServerMappers.request(serverRequest()).decidedBy, isNull);
    });
  });

  test('item code is item_code, not the row id; empty when missing', () {
    final lines = ServerMappers.request(serverRequest()).lines;
    expect(lines.map((l) => l.itemCode), ['I-1001', '']);
  });

  group('chat names', () {
    ChatAuthor author(Map<String, Object?> json) =>
        ServerMappers.message(json, myId: '3').author;

    test('the warehouse keeps its name', () {
      final a = author(serverMessage(senderName: 'انبار کاسپین'));
      expect(a.nameFa, 'انبار کاسپین');
      expect(a.kind, ChatAuthorKind.staff);
    });

    test('my messages are «شما», other owners «مالک»', () {
      final mine = author(
        serverMessage(senderId: 3, senderName: 'علیرضا', senderRole: 'admin'),
      );
      final other = author(
        serverMessage(
          senderId: 4,
          senderName: 'رضا احمدی',
          senderRole: 'owner',
        ),
      );
      expect((mine.nameFa, mine.isMe), ('شما', true));
      expect((other.nameFa, other.isMe), ('مالک', false));
    });
  });
}
