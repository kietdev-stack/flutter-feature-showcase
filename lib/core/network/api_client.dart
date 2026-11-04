import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../error/app_exception.dart';

final class ApiClient {
  ApiClient(Dio dio) : _dio = dio;

  final Dio _dio;

  Future<Map<String, Object?>> post(
    String path, {
    Map<String, Object?>? data,
  }) async {
    try {
      final response = await _dio.post<Map<String, Object?>>(path, data: data);
      return response.data ?? const {};
    } on DioException catch (error) {
      throw NetworkException(
        error.message ?? 'Request failed',
        statusCode: error.response?.statusCode,
      );
    }
  }

  static Dio createDio() => Dio(
    BaseOptions(
      baseUrl: AppConstants.demoApiBaseUrl,
      connectTimeout: AppConstants.networkTimeout,
      receiveTimeout: AppConstants.networkTimeout,
      headers: const {'Accept': 'application/json'},
    ),
  );
}
