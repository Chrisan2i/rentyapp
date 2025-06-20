import 'package:flutter/material.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart'; // Importa el modelo

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodModel paymentMethod;

  const PaymentMethodCard({super.key, required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    final details = paymentMethod.providerDetails;
    return _InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              TextButton(onPressed: () {}, child: const Text('Change'))
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.credit_card, color: Colors.grey),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${details['brand'] ?? 'Visa'} **** ${details['last4'] ?? '4242'}', style: const TextStyle(fontSize: 16, color: Colors.white)),
                  Text('Default payment method', style: TextStyle(color: Colors.grey.shade400)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
      child: child,
    );
  }
}