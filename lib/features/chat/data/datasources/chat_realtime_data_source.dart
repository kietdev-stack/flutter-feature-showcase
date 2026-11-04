import 'dart:async';

import '../../domain/entities/chat_message.dart';

abstract interface class ChatRealtimeDataSource {
  Stream<List<ChatMessage>> watchMessages();

  Future<void> sendMessage(String text);

  Future<void> dispose();
}

final class DemoChatRealtimeDataSource implements ChatRealtimeDataSource {
  DemoChatRealtimeDataSource() {
    _messages.addAll([
      ChatMessage(
        id: 'welcome',
        text: 'Send a message to try the realtime flow.',
        author: MessageAuthor.teammate,
        sentAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
    ]);
  }

  final _messages = <ChatMessage>[];
  final _updates = StreamController<List<ChatMessage>>.broadcast();

  @override
  Stream<List<ChatMessage>> watchMessages() async* {
    yield List.unmodifiable(_messages);
    yield* _updates.stream;
  }

  @override
  Future<void> sendMessage(String text) async {
    final normalized = text.trim();
    if (normalized.isEmpty) return;
    _messages.add(
      ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: normalized,
        author: MessageAuthor.me,
        sentAt: DateTime.now(),
      ),
    );
    _emit();

    await Future<void>.delayed(const Duration(milliseconds: 350));
    _messages.add(
      ChatMessage(
        id: '${DateTime.now().microsecondsSinceEpoch}-reply',
        text: 'Got it! This is a simulated reply.',
        author: MessageAuthor.teammate,
        sentAt: DateTime.now(),
      ),
    );
    _emit();
  }

  void _emit() => _updates.add(List.unmodifiable(_messages));

  @override
  Future<void> dispose() => _updates.close();
}
