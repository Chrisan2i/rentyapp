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
      child: isRenterView ? _buildCostBreakdown() : _buildEarningsBreakdown(),
    );
  }

  Widget _buildCostBreakdown() {
    final subtotal = rental.financials['subtotal'] ?? 120.0;
    final serviceFee = rental.financials['serviceFee'] ?? 8.0;
    final insurance = rental.financials['insurance'] ?? 12.0;
    final total = rental.financials['total'] ?? 140.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cost Breakdown', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildFinancialsRow('Daily Rate', '\$40.00'),
        _buildFinancialsRow('Rental Days (3)', '\$${subtotal.toStringAsFixed(2)}'),
        _buildFinancialsRow('Service Fee', '\$${serviceFee.toStringAsFixed(2)}'),
        _buildFinancialsRow('Insurance', '\$${insurance.toStringAsFixed(2)}'),
        const Divider(color: Color(0xFF3A3A3C), height: 24),
        _buildFinancialsRow('Total Paid', '\$${total.toStringAsFixed(2)}', isTotal: true),
      ],
    );
  }

  Widget _buildEarningsBreakdown() {
    final subtotal = rental.financials['subtotal'] ?? 120.0;
    final platformFee = rental.financials['platformFee'] ?? -8.0;
    final processingFee = rental.financials['processingFee'] ?? -3.60;
    final total = subtotal + platformFee + processingFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Earnings Breakdown', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildFinancialsRow('Daily Rate', '\$40.00'),
        _buildFinancialsRow('Rental Days (3)', '\$${subtotal.toStringAsFixed(2)}'),
        _buildFinancialsRow('Platform Fee', '\$${platformFee.toStringAsFixed(2)}', valueColor: Colors.red.shade400),
        _buildFinancialsRow('Processing Fee', '\$${processingFee.toStringAsFixed(2)}', valueColor: Colors.red.shade400),
        const Divider(color: Color(0xFF3A3A3C), height: 24),
        _buildFinancialsRow('Your Earnings', '\$${total.toStringAsFixed(2)}', isTotal: true),
      ],
    );
  }

  Widget _buildFinancialsRow(String label, String value, {bool isTotal = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isTotal ? Colors.white : Colors.grey.shade400, fontSize: 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(color: valueColor ?? (isTotal ? const Color(0xFF0A84FF) : Colors.white), fontSize: 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600)),
        ],
      ),
    );
  }
}