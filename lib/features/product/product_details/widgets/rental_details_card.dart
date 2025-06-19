// ARCHIVO: lib/features/product/widgets/rental_details_card.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
// ¡Asegúrate de importar tu modelo de precios!
import 'package:rentyapp/features/product/models/product_model.dart';
import 'section_card.dart';

class RentalDetailsCard extends StatelessWidget {
  final PricingDetails prices;
  final int minimumRentalDays;
  final double depositAmount;

  const RentalDetailsCard({
    super.key,
    required this.prices,
    required this.minimumRentalDays,
    required this.depositAmount,
  });

  @override
  Widget build(BuildContext context) {
    // --- MEJORA: Construimos la lista de widgets de precios de forma dinámica ---
    // Esto hace el código más limpio y fácil de mantener.
    final List<Widget> priceWidgets = [];

    // Verificamos si 'perDay' no es nulo antes de agregarlo.
    if (prices.perDay != null) {
      priceWidgets.add(
        // Llamamos al método toStringAsFixed() sobre una variable que sabemos que no es nula.
        _buildDetailRow('Price per Day:', '\$${prices.perDay!.toStringAsFixed(2)}'),
      );
    }

    // Hacemos lo mismo para 'perWeek'.
    if (prices.perWeek != null) {
      priceWidgets.add(
        _buildDetailRow('Price per Week:', '\$${prices.perWeek!.toStringAsFixed(2)}'),
      );
    }

    // Y para 'perMonth'.
    if (prices.perMonth != null) {
      priceWidgets.add(
        _buildDetailRow('Price per Month:', '\$${prices.perMonth!.toStringAsFixed(2)}'),
      );
    }

    // Ahora usamos esa lista en nuestro widget principal.
    return SectionCard(
      title: 'Rental Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Usamos la lista de widgets que acabamos de construir.
        // El operador 'spread' (...) inserta todos los elementos de la lista aquí.
        children: [
          ...priceWidgets,

          // Solo muestra el divisor si hay al menos un precio y hay otras reglas.
          if (priceWidgets.isNotEmpty)
            const Divider(color: AppColors.background, height: 24),

          // Sección de Reglas
          _buildDetailRow('Minimum Rental:', '$minimumRentalDays ${minimumRentalDays > 1 ? "Days" : "Day"}'),
          _buildDetailRow('Security Deposit:', '\$${depositAmount.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  // Este método no necesita cambios, está perfecto.
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Text(value, style: const TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}