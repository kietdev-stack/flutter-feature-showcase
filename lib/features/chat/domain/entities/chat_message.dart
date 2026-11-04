enum MessageAuthor { me, teammate }

final class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.author,
    required this.sentAt,
  });

  final String id;
  final String text;
  final MessageAuthor author;
  final DateTime sentAt;
}
