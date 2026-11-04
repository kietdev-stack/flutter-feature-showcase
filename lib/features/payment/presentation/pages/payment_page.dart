import 'package:flutter/material.dart';

import '../../domain/entities/payment_plan.dart';
import '../controllers/payment_controller.dart';

final class PaymentPage extends StatefulWidget {
  const PaymentPage({required this.controller, super.key});

  final PaymentController controller;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

final class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadPlans();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.controller,
    builder: (context, _) => ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Payments', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text('A demo purchase flow for the App Store and Google Play.'),
        const SizedBox(height: 22),
        if (widget.controller.isLoading)
          const Center(child: CircularProgressIndicator())
        else
          for (final plan in widget.controller.plans) ...[
            _PlanCard(
              plan: plan,
              isPurchasing: widget.controller.activeProductId == plan.id,
              onPurchase: () => widget.controller.purchase(plan),
            ),
            const SizedBox(height: 12),
          ],
        if (widget.controller.message case final message?) ...[
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
        ],
        const SizedBox(height: 16),
        TextButton(
          onPressed: widget.controller.restore,
          child: const Text('Restore purchases'),
        ),
        const SizedBox(height: 8),
        const Text(
          'No real payment is made in this demo.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

final class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.isPurchasing,
    required this.onPurchase,
  });

  final PaymentPlan plan;
  final bool isPurchasing;
  final VoidCallback onPurchase;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(plan.description),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: isPurchasing ? null : onPurchase,
            child: Text(isPurchasing ? '...' : plan.price),
          ),
        ],
      ),
    ),
  );
}
