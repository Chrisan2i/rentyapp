// lib/features/rentals/views/details_widgets/rental_info_section.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';

class RentalInfoSection extends StatelessWidget {
  final RentalModel rental;
  const RentalInfoSection({super.key, required this.rental});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rental Information', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildInfoRow('Order ID', '#RNT-${rental.rentalId.substring(0,8).toUpperCase()}'),
          _buildInfoRow('Payment Method', '•••• 4532'),
          _buildInfoRow('Pickup Method', 'In-person pickup'),
          _buildInfoRow('Return Method', 'In-person return'),
          _buildInfoRow('Agreement Status', 'Terms Accepted', valueColor: Colors.green),
          _buildInfoRow('Security Deposit', '\$200 (Held)'),
          _buildInfoRow('Request Date', DateFormat('MMM d, yyyy').format(rental.createdAt)),
          _buildInfoRow('Approval Date', DateFormat('MMM d, yyyy').format(rental.createdAt)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
          Text(value, style: TextStyle(color: valueColor ?? Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}