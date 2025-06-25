// lib/features/rentals/views/widgets/payment_method_card.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/widgets/info_card.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodModel? paymentMethod;
  final VoidCallback onChangePressed;
  final VoidCallback onAddPressed;

  const PaymentMethodCard({
    super.key,
    this.paymentMethod,
    required this.onChangePressed,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasPaymentMethod = paymentMethod != null;

    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Método de Pago',
                // ✨ MEJORA: Usando estilos del tema para consistencia.
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: hasPaymentMethod ? onChangePressed : onAddPressed,
                child: Text(hasPaymentMethod ? 'Cambiar' : 'Añadir'),
              )
            ],
          ),
          const SizedBox(height: 12),
          // ✨ MEJORA: Lógica simplificada.
          if (hasPaymentMethod)
            _buildPaymentMethodDetails(paymentMethod!, theme)
          else
            _buildNoPaymentMethod(theme),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodDetails(PaymentMethodModel method, ThemeData theme) {
    return Row(
      children: [
        const Icon(Icons.credit_card, color: Colors.grey),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              method.alias,
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
            ),
            if (method.isDefault)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                // ✨ MEJORA: Texto más conciso y estilo sutil.
                child: Text(
                  'Predeterminado',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade400),
                ),
              ),
          ],
        )
      ],
    );
  }

  Widget _buildNoPaymentMethod(ThemeData theme) {
    return Row(
      children: [
        // ✨ MEJORA: Ícono más descriptivo para "sin tarjeta".
        const Icon(Icons.credit_card_off_outlined, color: Colors.grey),
        const SizedBox(width: 16),
        Text(
          // ✨ MEJORA: Texto más accionable.
          'Añade un método de pago',
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey.shade400),
        ),
      ],
    );
  }
}