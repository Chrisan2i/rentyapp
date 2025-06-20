// lib/features/rentals/views/widgets/product_info_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/core/widgets/info_card.dart'; // Asegúrate de importar el InfoCard centralizado
import '../../models/rental_model.dart';

class ProductInfoCard extends StatelessWidget {
  final RentalModel rental;

  const ProductInfoCard({super.key, required this.rental});

  // Función para formatear las fechas
  String _formatDateRange(DateTime start, DateTime end) {
    final format = DateFormat('MMMM d');
    final days = end.difference(start).inDays.clamp(1, 999);
    return '${format.format(start)} – ${format.format(end)} (${days} ${days == 1 ? "day" : "days"})';
  }

  // Función para capitalizar la primera letra
  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  // Función para dar color al estado del alquiler
  Color _getStatusColor(RentalStatus status) {
    switch(status) {
      case RentalStatus.awaiting_payment:
        return Colors.orangeAccent;
      case RentalStatus.awaiting_delivery:
      case RentalStatus.ongoing:
        return Colors.blueAccent;
      case RentalStatus.completed:
        return Colors.green;
      case RentalStatus.cancelled:
      case RentalStatus.disputed:
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extraemos los datos del modelo `rental`.
    final productInfo = rental.productInfo;
    final financials = rental.financials;

    // --- ACCESO SEGURO A LOS DATOS ---
    // En lugar de acceder a productInfo['title'], accedemos a los campos específicos
    // que sabemos que existen según el `ProductModel`.
    final String title = productInfo['title'] ?? 'Título no disponible';

    // El 'subtitle' en el diseño original podría corresponder a 'description' en tu modelo.
    // Usaremos la descripción, pero la limitaremos a unas pocas líneas.
    final String description = productInfo['description'] ?? 'Descripción no disponible';

    // Obtenemos la primera imagen de la lista de imágenes.
    final List<String> images = List<String>.from(productInfo['images'] ?? []);
    final String? imageUrl = images.isNotEmpty ? images.first : null;

    // Cálculo seguro del precio por día.
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
              // --- IMAGEN DEL PRODUCTO (con manejo de nulos) ---
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: (imageUrl != null)
                    ? Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 80, height: 80,
                      color: Colors.grey.shade800,
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54)),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80, height: 80,
                      color: Colors.grey.shade800,
                      child: const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 30),
                    );
                  },
                )
                    : Container( // Fallback si no hay ninguna imagen en la lista
                  width: 80, height: 80,
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 30),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- TÍTULO Y DESCRIPCIÓN ---
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                      maxLines: 2, // Limitamos la descripción para que no ocupe mucho espacio
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // --- ESTADO DEL ALQUILER ---
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: _getStatusColor(rental.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _getStatusColor(rental.status).withOpacity(0.5))
                      ),
                      child: Text(
                        _capitalize(rental.status.name.replaceAll('_', ' ')),
                        style: TextStyle(color: _getStatusColor(rental.status), fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // --- RANGO DE FECHAS ---
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
          // --- FINANZAS ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${total.toStringAsFixed(2)} total',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                '\$${pricePerDay.toStringAsFixed(2)}/day',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}