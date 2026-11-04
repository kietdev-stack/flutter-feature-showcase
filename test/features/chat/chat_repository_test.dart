import 'package:flutter_feature_showcase/features/chat/data/datasources/chat_realtime_data_source.dart';
import 'package:flutter_feature_showcase/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('emits the sent message and simulated realtime reply', () async {
    final dataSource = DemoChatRealtimeDataSource();
    final repository = ChatRepositoryImpl(dataSource);
    final emissions = <int>[];
    final subscription = repository.watchMessages().listen(
      (messages) => emissions.add(messages.length),
    );

    await Future<void>.delayed(Duration.zero);
    await repository.sendMessage('Hello');
    await Future<void>.delayed(Duration.zero);

    expect(emissions, containsAllInOrder([1, 2, 3]));
    await subscription.cancel();
    await dataSource.dispose();
  });
}
