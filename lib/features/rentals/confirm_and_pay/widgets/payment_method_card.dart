// lib/features/rentals/views/widgets/payment_method_card.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/widgets/info_card.dart'; // Usa el widget InfoCard centralizado
import 'package:rentyapp/features/auth/models/payment_method.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodModel paymentMethod;
  final VoidCallback onChangePressed; // Añadimos un callback para el botón "Change"

  const PaymentMethodCard({
    super.key,
    required this.paymentMethod,
    required this.onChangePressed,
  });

  @override
  Widget build(BuildContext context) {
    final details = paymentMethod.providerDetails;
    return InfoCard( // Usamos el widget InfoCard
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              // El botón ahora usa el callback que le pasamos
              TextButton(onPressed: onChangePressed, child: const Text('Change'))
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
                  Text(paymentMethod.alias, style: const TextStyle(fontSize: 16, color: Colors.white)),
                  if (paymentMethod.isDefault)
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