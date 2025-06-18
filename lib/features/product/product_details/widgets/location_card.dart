import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'details_text_button.dart';
import 'section_card.dart';

/// Muestra la ubicación del producto y un botón para ver en el mapa.
class LocationCard extends StatelessWidget {
  final Map<String, dynamic> location;

  const LocationCard({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  '${location['city'] ?? 'Ciudad Desconocida'}, ${location['neighborhood'] ?? 'Área Desconocida'}',
                  style: const TextStyle(color: AppColors.white, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DetailsTextButton(
            text: 'View on Map',
            onPressed: () {
              debugPrint('Open map view for location: $location');
            },
          ),
        ],
      ),
    );
  }
}