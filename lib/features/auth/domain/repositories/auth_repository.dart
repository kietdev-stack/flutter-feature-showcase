import '../../../../core/utils/result.dart';
import '../entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<Result<AuthSession>> signIn({
    required String email,
    required String password,
  });
}
