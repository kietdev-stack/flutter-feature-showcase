import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';

final class ChatController extends ChangeNotifier {
  ChatController(this._repository) {
    _subscription = _repository.watchMessages().listen(
      (value) {
        messages = value;
        notifyListeners();
      },
      onError: (Object error) {
        errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  final ChatRepository _repository;
  late final StreamSubscription<List<ChatMessage>> _subscription;

  List<ChatMessage> messages = const [];
  String? errorMessage;
  bool isSending = false;

  Future<void> send(String text) async {
    if (text.trim().isEmpty || isSending) return;
    isSending = true;
    notifyListeners();
    try {
      await _repository.sendMessage(text);
    } on Object catch (error) {
      errorMessage = error.toString();
    } finally {
      isSending = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
