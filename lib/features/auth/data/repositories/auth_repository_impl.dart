import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Result<AuthSession>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return Success(session);
    } on ValidationException catch (error) {
      return Error(ValidationFailure(error.message));
    } on NetworkException catch (error) {
      return Error(NetworkFailure(error.message));
    } on Object catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }
}
