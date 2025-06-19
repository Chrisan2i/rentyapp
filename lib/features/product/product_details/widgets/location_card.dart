// lib/features/product/widgets/location_card.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'details_text_button.dart';
import 'section_card.dart';

/// Muestra la ubicación del producto y un botón para ver en el mapa.
class LocationCard extends StatelessWidget {
  final Map<String, dynamic> location;

  // --- MEJORA 1: Super parameter ---
  // Hacemos el constructor más limpio y moderno.
  const LocationCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    // Para mayor seguridad, extraemos los valores con un fallback.
    final String city = location['city'] as String? ?? 'Ciudad Desconocida';
    final String neighborhood = location['neighborhood'] as String? ?? 'Área Desconocida';

    return SectionCard(
      title: 'Location',
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$city, $neighborhood',
                  style: const TextStyle(color: AppColors.white, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DetailsTextButton(
            text: 'View on Map',
            onPressed: () {
              // TODO: Implementar la lógica para abrir el mapa.
              // Por ejemplo, usando el paquete url_launcher y las coordenadas.
              // final double lat = location['latitude'] ?? 0.0;
              // final double lon = location['longitude'] ?? 0.0;
              // final mapUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
              debugPrint('Abrir mapa para la ubicación: $location');
            },
          ),
        ],
      ),
    );
  }
}