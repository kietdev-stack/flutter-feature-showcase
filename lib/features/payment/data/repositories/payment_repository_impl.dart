import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/payment_plan.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/store_payment_data_source.dart';

final class PaymentRepositoryImpl implements PaymentRepository {
  const PaymentRepositoryImpl(this._dataSource);

  final StorePaymentDataSource _dataSource;

  @override
  Stream<PaymentEvent> get events => _dataSource.events;

  @override
  Future<Result<List<PaymentPlan>>> loadPlans() async {
    try {
      return Success(await _dataSource.loadPlans());
    } on PurchaseException catch (error) {
      return Error(PurchaseFailure(error.message));
    } on Object catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  @override
  Future<Result<void>> purchase(PaymentPlan plan) =>
      _run(() => _dataSource.purchase(plan.id));

  @override
  Future<Result<void>> restore() => _run(_dataSource.restore);

  Future<Result<void>> _run(Future<void> Function() operation) async {
    try {
      await operation();
      return const Success(null);
    } on PurchaseException catch (error) {
      return Error(PurchaseFailure(error.message));
    } on Object catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }
}
