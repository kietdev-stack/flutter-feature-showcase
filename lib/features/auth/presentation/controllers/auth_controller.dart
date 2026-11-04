import 'package:flutter/foundation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

final class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;

  bool isLoading = false;
  AuthSession? session;
  String? errorMessage;

  Future<void> signIn({required String email, required String password}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _repository.signIn(email: email, password: password);
    switch (result) {
      case Success<AuthSession>(:final value):
        session = value;
      case Error<AuthSession>(:final failure):
        errorMessage = failure is Failure
            ? failure.message
            : failure.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  void signOut() {
    session = null;
    errorMessage = null;
    notifyListeners();
  }
}
