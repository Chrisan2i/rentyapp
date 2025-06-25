// lib/features/rentals/views/details_widgets/financials_breakdown_card.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';

class FinancialsBreakdownCard extends StatelessWidget {
  final RentalModel rental;
  final bool isRenterView;

  const FinancialsBreakdownCard({super.key, required this.rental, required this.isRenterView});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: isRenterView ? _buildCostBreakdown(context) : _buildEarningsBreakdown(context),
    );
  }

  // ✨ MEJORA: Textos en español
  Widget _buildCostBreakdown(BuildContext context) {
    final subtotal = rental.financials['subtotal'] ?? 120.0;
    final serviceFee = rental.financials['serviceFee'] ?? 8.0;
    final insurance = rental.financials['insurance'] ?? 12.0;
    final total = rental.financials['total'] ?? 140.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Desglose de Costos', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildFinancialsRow('Tarifa por día', '\$40.00'),
        _buildFinancialsRow('Días de alquiler (3)', '\$${subtotal.toStringAsFixed(2)}'),
        _buildFinancialsRow('Comisión de servicio', '\$${serviceFee.toStringAsFixed(2)}'),
        _buildFinancialsRow('Seguro', '\$${insurance.toStringAsFixed(2)}'),
        const Divider(color: Color(0xFF3A3A3C), height: 24),
        _buildFinancialsRow('Total Pagado', '\$${total.toStringAsFixed(2)}', isTotal: true),
      ],
    );
  }

  // ✨ MEJORA: Textos en español
  Widget _buildEarningsBreakdown(BuildContext context) {
    final subtotal = rental.financials['subtotal'] ?? 120.0;
    final platformFee = rental.financials['platformFee'] ?? -8.0;
    final processingFee = rental.financials['processingFee'] ?? -3.60;
    final total = subtotal + platformFee + processingFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Desglose de Ganancias', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildFinancialsRow('Tarifa por día', '\$40.00'),
        _buildFinancialsRow('Días de alquiler (3)', '\$${subtotal.toStringAsFixed(2)}'),
        _buildFinancialsRow('Comisión de plataforma', '\$${platformFee.toStringAsFixed(2)}', valueColor: Colors.red.shade300),
        _buildFinancialsRow('Comisión de procesamiento', '\$${processingFee.toStringAsFixed(2)}', valueColor: Colors.red.shade300),
        const Divider(color: Color(0xFF3A3A3C), height: 24),
        _buildFinancialsRow('Tus Ganancias', '\$${total.toStringAsFixed(2)}', isTotal: true),
      ],
    );
  }

  Widget _buildFinancialsRow(String label, String value, {bool isTotal = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isTotal ? Colors.white : Colors.grey.shade400, fontSize: 14, fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal)),
          Text(value, style: TextStyle(color: valueColor ?? (isTotal ? Colors.blueAccent : Colors.white), fontSize: 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600)),
        ],
      ),
    );
  }
}