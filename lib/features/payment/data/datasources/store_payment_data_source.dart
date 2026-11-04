import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../core/error/app_exception.dart';
import '../../domain/entities/payment_plan.dart';

abstract interface class StorePaymentDataSource {
  Stream<PaymentEvent> get events;

  Future<List<PaymentPlan>> loadPlans();

  Future<void> purchase(String productId);

  Future<void> restore();
}

final class InAppPurchaseDataSource implements StorePaymentDataSource {
  InAppPurchaseDataSource(this._store) {
    _subscription = _store.purchaseStream.listen(_handlePurchases);
  }

  static const productIds = {'showcase_monthly', 'showcase_yearly'};

  final InAppPurchase _store;
  final _events = StreamController<PaymentEvent>.broadcast();
  final _products = <String, ProductDetails>{};
  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  Stream<PaymentEvent> get events => _events.stream;

  @override
  Future<List<PaymentPlan>> loadPlans() async {
    if (!await _store.isAvailable()) {
      throw const PurchaseException('The store is unavailable on this device.');
    }
    final response = await _store.queryProductDetails(productIds);
    if (response.error case final error?) {
      throw PurchaseException(error.message);
    }
    for (final product in response.productDetails) {
      _products[product.id] = product;
    }
    return response.productDetails
        .map(
          (product) => PaymentPlan(
            id: product.id,
            title: product.title,
            description: product.description,
            price: product.price,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> purchase(String productId) async {
    final product = _products[productId];
    if (product == null) {
      throw const PurchaseException('Product is not loaded.');
    }
    final started = await _store.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
    if (!started) {
      throw const PurchaseException('The purchase could not start.');
    }
  }

  @override
  Future<void> restore() => _store.restorePurchases();

  Future<void> _handlePurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      final status = switch (purchase.status) {
        PurchaseStatus.pending => PaymentStatus.pending,
        PurchaseStatus.purchased => PaymentStatus.purchased,
        PurchaseStatus.restored => PaymentStatus.restored,
        PurchaseStatus.error || PurchaseStatus.canceled => PaymentStatus.failed,
      };
      _events.add(
        PaymentEvent(
          productId: purchase.productID,
          status: status,
          message: purchase.error?.message,
        ),
      );
      if (purchase.pendingCompletePurchase) {
        await _store.completePurchase(purchase);
      }
    }
  }

  Future<void> dispose() async {
    await _subscription.cancel();
    await _events.close();
  }
}

final class DemoStorePaymentDataSource implements StorePaymentDataSource {
  final _events = StreamController<PaymentEvent>.broadcast();

  @override
  Stream<PaymentEvent> get events => _events.stream;

  @override
  Future<List<PaymentPlan>> loadPlans() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const [
      PaymentPlan(
        id: 'showcase_monthly',
        title: 'Monthly Pro',
        description: 'Flexible access, billed monthly.',
        price: r'$4.99',
      ),
      PaymentPlan(
        id: 'showcase_yearly',
        title: 'Annual Pro',
        description: 'Best value with two months included.',
        price: r'$49.99',
      ),
    ];
  }

  @override
  Future<void> purchase(String productId) async {
    _events.add(
      PaymentEvent(productId: productId, status: PaymentStatus.pending),
    );
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _events.add(
      PaymentEvent(productId: productId, status: PaymentStatus.purchased),
    );
  }

  @override
  Future<void> restore() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _events.add(
      const PaymentEvent(
        productId: 'showcase_yearly',
        status: PaymentStatus.restored,
      ),
    );
  }
}
