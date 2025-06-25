// lib/features/product/widgets/location_card.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'details_text_button.dart';
import 'section_card.dart';

/// Displays the product's location and a button to view it on a map.
class LocationCard extends StatelessWidget {
  final Map<String, dynamic> location;

  const LocationCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    // Safely extract location values with fallbacks.
    final String address = location['address'] as String? ?? 'Location not specified';
    final double? lat = location['latitude'] as double?;
    final double? lon = location['longitude'] as double?;

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
                  address,
                  style: const TextStyle(color: AppColors.white, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DetailsTextButton(
            text: 'View on Map',
            onPressed: () {
              // TODO: Implement map opening logic, e.g., using url_launcher.
              if (lat != null && lon != null) {
                // final mapUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
                debugPrint('Open map for coordinates: $lat, $lon');
              } else {
                debugPrint('Cannot open map, coordinates are missing.');
              }
            },
          ),
        ],
      ),
    );
  }
}