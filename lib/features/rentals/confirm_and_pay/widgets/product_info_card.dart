// lib/features/rentals/views/widgets/product_info_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/core/widgets/info_card.dart';
import '../../models/rental_model.dart';

class ProductInfoCard extends StatelessWidget {
  final RentalModel rental;

  const ProductInfoCard({super.key, required this.rental});

  String _formatDateRange(DateTime start, DateTime end) {
    // ✨ MEJORA: Formato de fecha localizado a español.
    final format = DateFormat('d \'de\' MMMM', 'es_ES');
    final days = end.difference(start).inDays.clamp(1, 999);
    final dayString = days == 1 ? "día" : "días";
    return '${format.format(start)} – ${format.format(end)} ($days $dayString)';
  }

  // ✨ MEJORA: Función dedicada para traducir el estado.
  String _getSpanishStatus(RentalStatus status) {
    switch (status) {
      case RentalStatus.awaiting_payment: return 'Pendiente de Pago';
      case RentalStatus.awaiting_delivery: return 'Pendiente de Entrega';
      case RentalStatus.ongoing: return 'En Curso';
      case RentalStatus.completed: return 'Completado';
      case RentalStatus.cancelled: return 'Cancelado';
      case RentalStatus.disputed: return 'En Disputa';
      default: return 'Desconocido';
    }
  }

  Color _getStatusColor(RentalStatus status) {
    switch (status) {
      case RentalStatus.awaiting_payment: return Colors.orangeAccent;
      case RentalStatus.awaiting_delivery:
      case RentalStatus.ongoing: return Colors.blueAccent;
      case RentalStatus.completed: return Colors.green;
      case RentalStatus.cancelled:
      case RentalStatus.disputed: return Colors.redAccent;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productInfo = rental.productInfo;
    final financials = rental.financials;
    final String title = productInfo['title'] ?? 'Título no disponible';
    final String description = productInfo['description'] ?? 'Descripción no disponible';
    final List<String> images = List<String>.from(productInfo['images'] ?? []);
    final String? imageUrl = images.isNotEmpty ? images.first : null;
    final days = rental.endDate.difference(rental.startDate).inDays.clamp(1, 999);
    final total = financials['total'] ?? 0.0;
    final pricePerDay = total > 0 && days > 0 ? total / days : 0.0;

    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: (imageUrl != null)
                    ? Image.network(
                  imageUrl,
                  width: 80, height: 80, fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 80, height: 80, color: Colors.grey.shade800,
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54)),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80, height: 80, color: Colors.grey.shade800,
                      child: const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 30),
                    );
                  },
                )
                    : Container(
                  width: 80, height: 80, color: Colors.grey.shade800,
                  child: const Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 30),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(description, style: TextStyle(fontSize: 14, color: Colors.grey.shade400), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    // ✨ MEJORA: Estilo del 'chip' de estado más refinado.
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: _getStatusColor(rental.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _getStatusColor(rental.status).withOpacity(0.5))),
                      child: Text(
                        _getSpanishStatus(rental.status),
                        style: TextStyle(color: _getStatusColor(rental.status), fontSize: 12, fontWeight: FontWeight.w500),
                      ),
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
              Text(
                _formatDateRange(rental.startDate, rental.endDate),
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                // ✨ MEJORA: Texto en español.
                '\$${total.toStringAsFixed(2)} Total',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                // ✨ MEJORA: Texto en español.
                '\$${pricePerDay.toStringAsFixed(2)}/día',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}