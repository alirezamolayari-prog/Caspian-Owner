import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/features/assistant/domain/assistant_message.dart';
import 'package:caspian_owner/features/assistant/domain/assistant_repository.dart';

class MockAssistantRepository implements AssistantRepository {
  const new(this._backend);

  final MockBackend _backend;

  @override
  Future<List<AssistantMessage>> history() => _backend.call(
    () => _backend.isEmpty
        ? const <AssistantMessage>[]
        : [..._backend.assistantHistory],
  );

  @override
  Future<AssistantMessage> ask(String text) =>
      _backend.call(() => _backend.answer(text));
}
