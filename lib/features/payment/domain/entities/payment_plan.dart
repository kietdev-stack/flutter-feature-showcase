final class PaymentPlan {
  const PaymentPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  final String id;
  final String title;
  final String description;
  final String price;
}

enum PaymentStatus { pending, purchased, restored, failed }

final class PaymentEvent {
  const PaymentEvent({
    required this.productId,
    required this.status,
    this.message,
  });

  final String productId;
  final PaymentStatus status;
  final String? message;
}
