import '../../../../core/utils/result.dart';
import '../entities/payment_plan.dart';

abstract interface class PaymentRepository {
  Stream<PaymentEvent> get events;

  Future<Result<List<PaymentPlan>>> loadPlans();

  Future<Result<void>> purchase(PaymentPlan plan);

  Future<Result<void>> restore();
}
