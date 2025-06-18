import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'section_card.dart';

/// Muestra los detalles de alquiler del producto.
class RentalDetailsCard extends StatelessWidget {
  final Map<String, dynamic> rentalDetails;

  const RentalDetailsCard({Key? key, required this.rentalDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Rental Details',
      child: Column(
        children: [
          _buildDetailRow('Minimum Rental Period:', rentalDetails['minRentalPeriod']?.toString() ?? 'N/A'),
          _buildDetailRow('Maximum Rental Period:', rentalDetails['maxRentalPeriod']?.toString() ?? 'N/A'),
          _buildDetailRow('Security Deposit:', '\$${rentalDetails['securityDeposit']?.toString() ?? '0'}'),
          _buildDetailRow('Insurance Available:', (rentalDetails['insuranceAvailable'] == true) ? 'Yes' : 'No'),
          _buildDetailRow('Cancellation Policy:', rentalDetails['cancellationPolicy']?.toString() ?? 'Flexible'),
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