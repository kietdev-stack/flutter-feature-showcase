import 'package:flutter/material.dart';

import '../../domain/entities/chat_message.dart';
import '../controllers/chat_controller.dart';

final class ChatPage extends StatefulWidget {
  const ChatPage({required this.controller, super.key});

  final ChatController controller;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

final class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Realtime chat',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              const Text(
                'Messages on this screen are updated through a Stream.',
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: AnimatedBuilder(
          animation: widget.controller,
          builder: (context, _) => ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: widget.controller.messages.length,
            itemBuilder: (context, index) {
              final message = widget.controller.messages[index];
              return _MessageBubble(message: message);
            },
          ),
        ),
      ),
      SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Write a message',
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _send,
                icon: const Icon(Icons.arrow_upward_rounded),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  void _send() {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;
    _messageController.clear();
    widget.controller.send(text);
  }
}

final class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isMine = message.author == MessageAuthor.me;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMine
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isMine ? Theme.of(context).colorScheme.onPrimary : null,
          ),
        ),
      ),
    );
  }
}
