import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/chat/data/datasources/chat_realtime_data_source.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/presentation/controllers/chat_controller.dart';
import '../../features/payment/data/datasources/store_payment_data_source.dart';
import '../../features/payment/data/repositories/payment_repository_impl.dart';
import '../../features/payment/domain/repositories/payment_repository.dart';
import '../../features/payment/presentation/controllers/payment_controller.dart';
import '../network/api_client.dart';
import '../network/auth_interceptor.dart';

final GetIt getIt = GetIt.instance;

void configureDependencies() {
  if (getIt.isRegistered<AuthController>()) return;

  getIt
    ..registerLazySingleton<Dio>(() {
      final dio = ApiClient.createDio();
      dio.interceptors.add(
        AuthInterceptor(() => getIt<AuthController>().session?.token),
      );
      return dio;
    })
    ..registerLazySingleton<ApiClient>(() => ApiClient(getIt()))
    ..registerLazySingleton<AuthRemoteDataSource>(DemoAuthRemoteDataSource.new)
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()))
    ..registerLazySingleton<AuthController>(() => AuthController(getIt()))
    ..registerLazySingleton<ChatRealtimeDataSource>(
      DemoChatRealtimeDataSource.new,
    )
    ..registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(getIt()))
    ..registerLazySingleton<ChatController>(() => ChatController(getIt()))
    ..registerLazySingleton<StorePaymentDataSource>(
      DemoStorePaymentDataSource.new,
    )
    ..registerLazySingleton<PaymentRepository>(
      () => PaymentRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<PaymentController>(
      () => PaymentController(getIt()),
    );
}
