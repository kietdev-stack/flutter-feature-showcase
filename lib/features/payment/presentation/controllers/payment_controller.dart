import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/payment_plan.dart';
import '../../domain/repositories/payment_repository.dart';

final class PaymentController extends ChangeNotifier {
  PaymentController(this._repository) {
    _subscription = _repository.events.listen(_onPaymentEvent);
  }

  final PaymentRepository _repository;
  late final StreamSubscription<PaymentEvent> _subscription;

  List<PaymentPlan> plans = const [];
  String? activeProductId;
  String? message;
  bool isLoading = false;

  Future<void> loadPlans() async {
    isLoading = true;
    notifyListeners();
    final result = await _repository.loadPlans();
    switch (result) {
      case Success<List<PaymentPlan>>(:final value):
        plans = value;
      case Error<List<PaymentPlan>>(:final failure):
        message = _failureMessage(failure);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> purchase(PaymentPlan plan) async {
    activeProductId = plan.id;
    message = null;
    notifyListeners();
    final result = await _repository.purchase(plan);
    if (result case Error<void>(:final failure)) {
      activeProductId = null;
      message = _failureMessage(failure);
      notifyListeners();
    }
  }

  Future<void> restore() async {
    message = 'Checking previous purchases...';
    notifyListeners();
    final result = await _repository.restore();
    if (result case Error<void>(:final failure)) {
      message = _failureMessage(failure);
      notifyListeners();
    }
  }

  void _onPaymentEvent(PaymentEvent event) {
    switch (event.status) {
      case PaymentStatus.pending:
        message = 'Purchase pending...';
      case PaymentStatus.purchased:
        activeProductId = null;
        message = 'Purchase verified and entitlement activated.';
      case PaymentStatus.restored:
        activeProductId = null;
        message = 'Previous entitlement restored.';
      case PaymentStatus.failed:
        activeProductId = null;
        message = event.message ?? 'Purchase failed.';
    }
    notifyListeners();
  }

  String _failureMessage(Object failure) =>
      failure is Failure ? failure.message : failure.toString();

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
