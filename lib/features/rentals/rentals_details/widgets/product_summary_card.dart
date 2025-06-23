// lib/features/rentals/views/details_widgets/product_summary_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/rentals/my_rentals/widgets/rental_card_widget.dart'; // Para extensiones de status

class ProductSummaryCard extends StatelessWidget {
  final RentalModel rental;
  final bool isRenterView;

  const ProductSummaryCard({super.key, required this.rental, required this.isRenterView});

  @override
  Widget build(BuildContext context) {
    final title = rental.productInfo['title'] ?? 'N/A';
    final subTitle = rental.productInfo['subtitle'] ?? 'No subtitle provided';
    final total = rental.financials['total'] ?? 0.0;
    // Cálculo de ganancias de ejemplo
    final earnings = total - (rental.financials['serviceFee'] ?? 0.0) - (rental.financials['platformFee'] ?? 0.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  rental.productInfo['imageUrl'] ?? 'https://via.placeholder.com/150',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    if (subTitle.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(subTitle, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${(isRenterView ? total : earnings).toStringAsFixed(2)}',
                      style: const TextStyle(color: Color(0xFF34C759), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      isRenterView ? 'total' : 'total earned',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                  ],
                ),
              ),
              StatusChip(status: rental.status)
            ],
          ),
          const Divider(color: Color(0xFF3A3A3C), height: 32),
          // <<<--- CORRECCIÓN DEL OVERFLOW AQUÍ ---<<<
          Row(
            children: [
              Expanded(
                child: InfoColumn(
                    icon: Icons.calendar_today_outlined,
                    label: 'Rental Period',
                    value: '${DateFormat('MMM d').format(rental.startDate)} - ${DateFormat('MMM d').format(rental.endDate)}'),
              ),
              Expanded(
                child: InfoColumn(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: rental.productInfo['location'] ?? 'Downtown Studio'),
              ),
              Expanded(
                child: InfoColumn(
                    icon: Icons.delivery_dining_outlined,
                    label: 'Pickup Method',
                    value: 'In-person'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widgets de soporte que puedes mover a su propio archivo `common_widgets.dart` si quieres
class InfoColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const InfoColumn({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey.shade500, size: 14),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class StatusChip extends StatelessWidget {
  final RentalStatus status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.displayColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.displayColor, width: 1.5),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(color: status.displayColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}