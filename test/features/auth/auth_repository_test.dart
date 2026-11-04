import 'package:flutter_feature_showcase/core/error/failure.dart';
import 'package:flutter_feature_showcase/core/utils/result.dart';
import 'package:flutter_feature_showcase/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_feature_showcase/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_feature_showcase/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final repository = AuthRepositoryImpl(DemoAuthRemoteDataSource());

  test('maps a successful data-source response to a session', () async {
    final result = await repository.signIn(
      email: 'demo@example.com',
      password: 'password123',
    );

    expect(result, isA<Success<AuthSession>>());
  });

  test('maps invalid credentials to a typed validation failure', () async {
    final result = await repository.signIn(
      email: 'wrong@example.com',
      password: 'password123',
    );

    expect(result, isA<Error<AuthSession>>());
    final failure = (result as Error<AuthSession>).failure;
    expect(failure, isA<ValidationFailure>());
  });
}
