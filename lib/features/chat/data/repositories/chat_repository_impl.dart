import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_realtime_data_source.dart';

final class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._dataSource);

  final ChatRealtimeDataSource _dataSource;

  @override
  Future<void> sendMessage(String text) => _dataSource.sendMessage(text);

  @override
  Stream<List<ChatMessage>> watchMessages() => _dataSource.watchMessages();
}
