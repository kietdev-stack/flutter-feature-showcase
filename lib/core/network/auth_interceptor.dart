import 'package:dio/dio.dart';

typedef TokenReader = String? Function();

final class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._readToken);

  final TokenReader _readToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
