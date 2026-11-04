sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;
}

final class NetworkException extends AppException {
  const NetworkException(super.message, {this.statusCode});

  final int? statusCode;
}

final class ValidationException extends AppException {
  const ValidationException(super.message);
}

final class PurchaseException extends AppException {
  const PurchaseException(super.message);
}
