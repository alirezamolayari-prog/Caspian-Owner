import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/chat/domain/chat_message.dart';
import 'package:caspian_owner/features/chat/domain/chat_repository.dart';
import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart'
    show AsyncNotifierProviderFamily, FutureProviderFamily;
import 'package:uuid/uuid.dart';

/// A message in the chat, including ones still being sent by me.
class ChatEntry {
  const new(this.message, {this.sending = false, this.failed = false});

  final ChatMessage message;
  final bool sending;
  final bool failed;
}

/// The loaded part of a chat: [entries] oldest first; older pages load on
/// demand (scrolling up).
class ChatState {
  const new({
    required this.entries,
    required this.hasOlder,
    this.loadingOlder = false,
  });

  final List<ChatEntry> entries;
  final bool hasOlder;
  final bool loadingOlder;

  ChatState copyWith({
    List<ChatEntry>? entries,
    bool? hasOlder,
    bool? loadingOlder,
  }) => ChatState(
    entries: entries ?? this.entries,
    hasOlder: hasOlder ?? this.hasOlder,
    loadingOlder: loadingOlder ?? this.loadingOlder,
  );
}

final AsyncNotifierProviderFamily<ChatController, ChatState, String>
chatControllerProvider = AsyncNotifierProvider.family(ChatController.new);

/// Chat about one request, in pages (newest first loaded). Sent messages
/// show at once; a failed send stays visible with «تلاش دوباره» and reuses
/// its id, so it is never duplicated.
class ChatController extends AsyncNotifier<ChatState> {
  new(this.requestId);

  final String requestId;

  static const int pageSize = ChatRepository.pageSize;

  @override
  Future<ChatState> build() async {
    final page = await ref.read(chatRepositoryProvider).messages(requestId);
    return ChatState(
      entries: [for (final m in page) ChatEntry(m)],
      hasOlder: page.length == pageSize,
    );
  }

  /// Loads the page before the oldest loaded message.
  Future<void> loadOlder() async {
    final current = state.value;
    if (current == null || !current.hasOlder || current.loadingOlder) return;
    final oldest = current.entries.firstOrNull?.message.id;
    state = AsyncData(current.copyWith(loadingOlder: true));
    try {
      final page = await ref
          .read(chatRepositoryProvider)
          .messages(requestId, before: oldest);
      final now = state.value ?? current;
      state = AsyncData(
        now.copyWith(
          entries: [for (final m in page) ChatEntry(m), ...now.entries],
          hasOlder: page.length == pageSize,
          loadingOlder: false,
        ),
      );
    } on Object {
      // Keep what is shown; scrolling up again retries.
      state = AsyncData((state.value ?? current).copyWith(loadingOlder: false));
    }
  }

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final auth = ref.read(authControllerProvider);
    final draft = ChatMessage(
      id: const Uuid().v4(),
      requestId: requestId,
      author: ChatAuthor(
        kind: ChatAuthorKind.owner,
        nameFa: auth is SignedIn ? auth.session.owner.nameFa : '',
        isMe: true,
      ),
      text: trimmed,
      sentAt: clock.now(),
    );
    await _deliver(draft);
  }

  /// Retries a message whose send failed.
  Future<void> retry(ChatMessage message) => _deliver(message);

  Future<void> _deliver(ChatMessage draft) async {
    _upsert(ChatEntry(draft, sending: true));
    try {
      final sent = await ref
          .read(chatRepositoryProvider)
          .send(requestId: requestId, text: draft.text, clientId: draft.id);
      _replace(draft.id, ChatEntry(sent));
    } on Object {
      _upsert(ChatEntry(draft, failed: true));
    }
  }

  ChatState get _current =>
      state.value ?? const ChatState(entries: [], hasOlder: false);

  void _upsert(ChatEntry entry) {
    final current = _current;
    final entries = [...current.entries];
    final index = entries.indexWhere((e) => e.message.id == entry.message.id);
    if (index < 0) {
      entries.add(entry);
    } else {
      entries[index] = entry;
    }
    state = AsyncData(current.copyWith(entries: entries));
  }

  void _replace(String draftId, ChatEntry entry) {
    final current = _current;
    state = AsyncData(
      current.copyWith(
        entries: [
          for (final e in current.entries)
            if (e.message.id == draftId) entry else e,
        ],
      ),
    );
  }
}

/// When the owner last saw the chat about a request: the newest message
/// time they saw, kept on the phone (wiped on logout). The «گفتگو» tile
/// shows a dot while a newer message from someone else exists.
final FutureProviderFamily<DateTime?, String> chatLastReadProvider =
    FutureProvider.family((ref, requestId) async {
      final cached = await ref
          .read(cacheStoreProvider)
          .get(
            'chat_read:$requestId',
            (json) => DateTime.parse(json! as String),
          );
      return cached?.value;
    });

/// Marks the chat about [requestId] as read up to [seen].
Future<void> markChatRead(
  WidgetRef ref,
  String requestId,
  DateTime seen,
) async {
  await ref
      .read(cacheStoreProvider)
      .put('chat_read:$requestId', seen.toUtc().toIso8601String());
  ref.invalidate(chatLastReadProvider(requestId));
}
