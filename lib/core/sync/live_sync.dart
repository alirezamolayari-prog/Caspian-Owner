import 'dart:async';

import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/network/changes_feed.dart';
import 'package:caspian_owner/core/network/server_mappers.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/chat/application/chat_controller.dart';
import 'package:caspian_owner/features/chat/domain/chat_message.dart';
import 'package:caspian_owner/features/home/application/home_controller.dart';
import 'package:caspian_owner/features/requests/application/requests_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final liveSyncProvider = NotifierProvider<LiveSyncController, DateTime?>(
  LiveSyncController.new,
);

/// While the app is open and signed in, asks Caspian Server «what changed
/// since …?» (`GET /changes`) every [ApiConfig.liveSyncInterval]:
/// - changed requests → lists, Home and that request's detail reload;
/// - new messages → an open chat shows them, the «گفتگو» tile updates.
///
/// The first `since` is the server's own clock, so a wrong phone clock
/// can't hide anything. Offline, it just tries again on the next tick.
/// State: the `since` of the last successful check (null before the first).
///
/// `app.dart` starts it when the app is visible and signed in, and stops it
/// in the background (no polling, no battery use there).
class LiveSyncController extends Notifier<DateTime?> {
  Timer? _timer;
  DateTime? _since;
  bool _busy = false;

  @override
  DateTime? build() {
    ref.onDispose(() => _timer?.cancel());
    return null;
  }

  bool get running => _timer != null;

  void start() {
    if (_timer != null) return;
    _timer = Timer.periodic(
      ApiConfig.liveSyncInterval,
      (_) => unawaited(pollOnce()),
    );
    unawaited(pollOnce());
  }

  /// [reset] forgets `since` (after logout: the next owner starts fresh).
  void stop({bool reset = false}) {
    _timer?.cancel();
    _timer = null;
    if (reset) {
      _since = null;
      // Only when there is something to clear: app.dart calls this while
      // the first frame builds, and providers can't change during a build.
      if (state != null) state = null;
    }
  }

  /// One check. Public for tests and pull-to-refresh.
  Future<void> pollOnce() async {
    if (_busy ||
        ref.read(dataSourceProvider) != DataSource.api ||
        ref.read(authControllerProvider) is! SignedIn) {
      return;
    }
    _busy = true;
    try {
      final feed = ref.read(changesFeedProvider);
      final since = _since ??= await feed.serverNow();
      final changes = await feed.since(since);
      _since = changes.nextSince;
      if (!changes.isEmpty) _apply(changes);
      state = changes.nextSince;
    } on ApiException {
      // Offline or a server error: next tick. (401 already signed out.)
    } finally {
      _busy = false;
    }
  }

  void _apply(ServerChanges changes) {
    if (changes.requests.isNotEmpty) {
      ref
        ..invalidate(requestsControllerProvider)
        ..invalidate(homeControllerProvider);
    }
    final myId = switch (ref.read(authControllerProvider)) {
      SignedIn(:final session) => session.owner.id,
      SignedOut() => null,
    };
    final byRequest = <String, List<ChatMessage>>{};
    for (final json in changes.messages) {
      final message = ServerMappers.message(json, myId: myId);
      (byRequest[message.requestId] ??= []).add(message);
    }
    final touched = {
      for (final r in changes.requests) '${r['id']}',
      ...byRequest.keys,
    };
    for (final id in touched) {
      ref.invalidate(requestDetailProvider(id));
    }
    for (final MapEntry(key: id, value: messages) in byRequest.entries) {
      // Only chats that are open (or were opened) need the new messages.
      if (ref.exists(chatControllerProvider(id))) {
        ref.read(chatControllerProvider(id).notifier).mergeIncoming(messages);
      }
    }
  }
}
