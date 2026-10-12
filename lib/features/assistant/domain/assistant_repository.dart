import 'package:caspian_owner/features/assistant/domain/assistant_message.dart';

/// «دستیار کاسپین» (contract: `/v1/assistant/messages`). Mock answers in
/// this phase; the real assistant will run on the server.
abstract interface class AssistantRepository {
  /// Oldest first.
  Future<List<AssistantMessage>> history();

  /// Returns the assistant's answer to [text].
  Future<AssistantMessage> ask(String text);
}
