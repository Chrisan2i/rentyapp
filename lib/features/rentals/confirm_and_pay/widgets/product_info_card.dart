import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/rental_model.dart';

class ProductInfoCard extends StatelessWidget {
  final RentalModel rental;

  const ProductInfoCard({super.key, required this.rental});

  String _formatDateRange(DateTime start, DateTime end) {
    final format = DateFormat('MMMM d');
    // Aseguramos que el cálculo de días sea al menos 1
    final days = end.difference(start).inDays.clamp(1, 999);
    return '${format.format(start)} – ${format.format(end)} (${days} days)';
  }

  @override
  Widget build(BuildContext context) {
    final product = rental.productInfo;
    final financials = rental.financials;
    final days = rental.endDate.difference(rental.startDate).inDays.clamp(1, 999);
    final pricePerDay = (financials['total'] ?? 0) / days;

    return _InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.question_mark, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product['title'] ?? 'Professional DSLR Camera', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(product['subtitle'] ?? 'Canon EOS R5 with 24-70mm lens', style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.blue.shade800.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
                      child: const Text('accepted', style: TextStyle(color: Colors.blueAccent, fontSize: 12)),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: Colors.grey.shade400, size: 16),
              const SizedBox(width: 8),
              Text(_formatDateRange(rental.startDate, rental.endDate), style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${(financials['total'] ?? 0).toStringAsFixed(2)} total', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('\$${pricePerDay.toStringAsFixed(2)}/day', style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
      child: child,
    );
  }
}