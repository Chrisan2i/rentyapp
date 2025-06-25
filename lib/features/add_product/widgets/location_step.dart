// lib/features/add_product/widgets/location_step.dart
import 'package:flutter/material.dart';

class LocationStep extends StatelessWidget {
  final TextEditingController addressController;
  final double? latitude;
  final double? longitude;
  final VoidCallback onUseCurrentLocation;
  final bool offersDelivery;
  final VoidCallback onToggleDelivery;

  const LocationStep({
    super.key,
    required this.addressController,
    this.latitude,
    this.longitude,
    required this.onUseCurrentLocation,
    required this.offersDelivery,
    required this.onToggleDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Set Location',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Specify where your item is located.',
          style: TextStyle(color: Color(0xFF999999), fontSize: 14),
        ),
        const SizedBox(height: 24),

        TextField(
          controller: addressController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Address or Area',
            labelStyle: TextStyle(color: Color(0xFF999999)),
            filled: true,
            fillColor: Color(0xFF1A1A1A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFF0085FF)),
            ),
          ),
        ),
        const SizedBox(height: 16),

        ElevatedButton.icon(
          onPressed: onUseCurrentLocation,
          icon: const Icon(Icons.my_location, size: 20),
          label: const Text("Use Current Location (Mock)"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0085FF).withOpacity(0.15),
            foregroundColor: const Color(0xFF0085FF),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
        ),
        if (latitude != null && longitude != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Center(
              child: Text(
                '📍 Location Set: (${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)})',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

        const SizedBox(height: 24),

        // Delivery Option
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Offer Delivery?',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Switch(
                value: offersDelivery,
                onChanged: (_) => onToggleDelivery(),
                activeColor: const Color(0xFF0085FF),
                inactiveTrackColor: Colors.grey.shade700,
              ),
            ],
          ),
        ),
      ],
    );
  }
}