// lib/features/rentals/views/widgets/payment_bottom_bar.dart

import 'package:flutter/material.dart';

class PaymentBottomBar extends StatelessWidget {
  final double totalAmount;
  final bool isLoading;
  final bool isTermsAgreed;
  final VoidCallback onPayPressed;

  const PaymentBottomBar({
    super.key,
    required this.totalAmount,
    required this.isLoading,
    required this.isTermsAgreed,
    required this.onPayPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isButtonEnabled = !isLoading && isTermsAgreed;

    return Container(
      // ✨ MEJORA: Aumenta el padding inferior para mejor separación en móviles modernos.
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        border: Border(top: BorderSide(color: Color(0xFF222222))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                // ✨ MEJORA: Estilo más refinado y consistente con el tema.
                backgroundColor: Colors.blueAccent,
                disabledBackgroundColor: Colors.grey.shade800,
                disabledForegroundColor: Colors.grey.shade500,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: isButtonEnabled ? onPayPressed : null,
              child: isLoading
                  ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
                  : Text(
                // ✨ MEJORA: Texto en español.
                'Pagar \$${totalAmount.toStringAsFixed(2)} y Confirmar',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            // ✨ MEJORA: Texto en español.
            'Pago seguro con Stripe • Tus datos están encriptados',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}