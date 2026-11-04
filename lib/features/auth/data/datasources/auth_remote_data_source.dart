import '../../../../core/error/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/auth_session.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthSession> signIn({required String email, required String password});
}

final class RestAuthRemoteDataSource implements AuthRemoteDataSource {
  const RestAuthRemoteDataSource(this._client);

  final ApiClient _client;

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final json = await _client.post(
      '/v1/auth/sign-in',
      data: {'email': email, 'password': password},
    );
    return AuthSession(
      userId: json['user_id']! as String,
      email: json['email']! as String,
      token: json['access_token']! as String,
    );
  }
}

final class DemoAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (email.trim().toLowerCase() != 'demo@example.com' ||
        password != 'password123') {
      throw const ValidationException('Use the demo credentials shown below.');
    }
    return AuthSession(
      userId: 'demo-user',
      email: email.trim().toLowerCase(),
      token: 'demo-session-token',
    );
  }
}
