// lib/features/rentals/views/widgets/rental_terms_card.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rentyapp/core/utils/terms_and_conditions.dart';
import 'package:rentyapp/core/widgets/info_card.dart';

class RentalTermsCard extends StatelessWidget {
  final bool termsAgreed;
  final ValueChanged<bool?> onTermsChanged;

  const RentalTermsCard({
    super.key,
    required this.termsAgreed,
    required this.onTermsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // ✨ MEJORA: Texto ya estaba en español, se mantiene.
            'TÉRMINOS Y CONDICIONES',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // ✨ MEJORA: Textos en español.
          _buildTermItem('Cancelación gratuita hasta 48h antes del inicio.'),
          _buildTermItem('Depósito de seguridad retenido hasta la devolución.'),
          _buildTermItem('Penalización por cancelación tardía: 50% del total.'),
          _buildTermItem('El arrendatario cubre costos por daños al producto.'),
          const SizedBox(height: 16),
          // ✨ MEJORA: Mejor UX al hacer toda la fila clickeable.
          InkWell(
            onTap: () => onTermsChanged(!termsAgreed),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: termsAgreed,
                      onChanged: onTermsChanged,
                      activeColor: Colors.blueAccent,
                      checkColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade400),
                        children: [
                          const TextSpan(text: 'He leído y acepto los '),
                          TextSpan(
                            text: 'Términos y Condiciones',
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _showTermsDialog(context);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E), // Dark theme for modal
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Términos y Condiciones',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Text(
                        rentyTermsAndConditions, // Assuming this variable holds the full text
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade300, height: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blueAccent),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar', style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text('• ', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}