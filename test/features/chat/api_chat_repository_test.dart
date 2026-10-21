import 'package:caspian_owner/features/chat/data/api_chat_repository.dart';
import 'package:caspian_owner/features/chat/domain/chat_message.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_server.dart';

void main() {
  late FakeServer server;
  late ApiChatRepository repository;

  setUp(() {
    server = FakeServer();
    repository = ApiChatRepository(server.client(), myId: () => '3');
  });

  test('messages oldest first; warehouse is staff, mine are mine', () async {
    server.on(
      'GET',
      '/requests/5/messages',
      FakeServer.json([
        serverMessage(text: 'سلام، فوری است'),
        serverMessage(
          id: 2,
          senderId: 3,
          senderName: 'مالک ۱',
          senderRole: 'owner',
          text: 'بررسی می‌کنم',
          createdAt: '2026-10-21T08:06:00Z',
        ),
      ]),
    );

    final messages = await repository.messages('5');

    expect(messages.map((m) => m.text), ['سلام، فوری است', 'بررسی می‌کنم']);
    expect(messages.first.author.kind, ChatAuthorKind.staff);
    expect(messages.first.author.isMe, isFalse);
    expect(messages.last.author.kind, ChatAuthorKind.owner);
    expect(messages.last.author.isMe, isTrue);
  });

  test('pages are cut from the full chat', () async {
    server.on(
      'GET',
      '/requests/5/messages',
      FakeServer.json([for (var i = 1; i <= 5; i++) serverMessage(id: i)]),
    );

    final newest = await repository.messages('5', limit: 2);
    expect(newest.map((m) => m.id), ['4', '5']);
    final older = await repository.messages('5', before: '4', limit: 2);
    expect(older.map((m) => m.id), ['2', '3']);
  });

  test('send posts the text and returns the saved message', () async {
    server.on(
      'POST',
      '/requests/5/messages',
      FakeServer.json(
        serverMessage(id: 9, senderId: 3, senderRole: 'owner', text: 'باشه'),
      ),
    );

    final sent = await repository.send(
      requestId: '5',
      text: 'باشه',
      clientId: 'c1',
    );

    expect(sent.id, '9');
    expect(sent.author.isMe, isTrue);
    expect(server.requests.single.data, {'text': 'باشه'});
  });
}
