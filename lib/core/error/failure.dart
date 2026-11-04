sealed class Failure {
  const Failure(this.message);

  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class PurchaseFailure extends Failure {
  const PurchaseFailure(super.message);
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
