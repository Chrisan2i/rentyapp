// ARCHIVO: lib/features/product/widgets/rental_details_card.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/product/models/product_model.dart'; // Importamos el modelo
import 'section_card.dart';

class RentalDetailsCard extends StatelessWidget {
  // <<<--- ACTUALIZADO: Acepta el objeto de precios y las otras propiedades por separado ---<<<
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
    return SectionCard(
      title: 'Rental Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de Precios
          _buildDetailRow('Price per Day:', '\$${prices.perDay.toStringAsFixed(2)}'),
          if (prices.perWeek != null)
            _buildDetailRow('Price per Week:', '\$${prices.perWeek!.toStringAsFixed(2)}'),
          if (prices.perMonth != null)
            _buildDetailRow('Price per Month:', '\$${prices.perMonth!.toStringAsFixed(2)}'),

          const Divider(color: AppColors.background, height: 24),

          // Sección de Reglas
          _buildDetailRow('Minimum Rental:', '$minimumRentalDays Days'),
          _buildDetailRow('Security Deposit:', '\$${depositAmount.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

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