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
    required this.latitude,
    required this.longitude,
    required this.onUseCurrentLocation,
    required this.offersDelivery,
    required this.onToggleDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Location',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          TextField(
            controller: addressController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Address (visible to renters)',
              labelStyle: TextStyle(color: Color(0xFF999999)),
              filled: true,
              fillColor: Color(0xFF1A1A1A),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onUseCurrentLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text("Use Current Location"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0085FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (latitude != null && longitude != null)
                Flexible(
                  child: Text(
                    '📍 ($latitude, $longitude)',
                    style: const TextStyle(color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Offer Delivery?',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              Switch(
                value: offersDelivery,
                onChanged: (_) => onToggleDelivery(),
                activeColor: const Color(0xFF0085FF),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
