// lib/features/rentals/views/details_widgets/rental_info_section.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';

class RentalInfoSection extends StatelessWidget {
  final RentalModel rental;
  const RentalInfoSection({super.key, required this.rental});

  @override
  Widget build(BuildContext context) {
    // ✨ MEJORA: Uso de Theme para consistencia
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // ✨ MEJORA: Texto en español
            'Información del Alquiler',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // ✨ MEJORA: Todos los textos traducidos a español
          _buildInfoRow('ID del Pedido', '#RNT-${rental.rentalId.substring(0, 8).toUpperCase()}'),
          _buildInfoRow('Método de Pago', '•••• 4532'), // Dato de ejemplo
          _buildInfoRow('Método de Recogida', 'En persona'),
          _buildInfoRow('Método de Devolución', 'En persona'),
          _buildInfoRow('Estado del Acuerdo', 'Términos aceptados', valueColor: Colors.green),
          _buildInfoRow('Depósito de Garantía', '\$200 (Retenido)'),
          // ✨ MEJORA: Formato de fecha localizado
          _buildInfoRow('Fecha de Solicitud', DateFormat('d MMM, yyyy', 'es_ES').format(rental.createdAt)),
          _buildInfoRow('Fecha de Aprobación', DateFormat('d MMM, yyyy', 'es_ES').format(rental.createdAt)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}