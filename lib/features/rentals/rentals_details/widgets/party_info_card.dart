// lib/features/rentals/views/details_widgets/party_info_card.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';

class PartyInfoCard extends StatelessWidget {
  final RentalModel rental;
  final bool isRenterView;

  const PartyInfoCard({super.key, required this.rental, required this.isRenterView});

  @override
  Widget build(BuildContext context) {
    final info = isRenterView ? rental.ownerInfo : rental.renterInfo;
    final name = info['fullName'] ?? 'N/A';
    final title = isRenterView ? 'Owner Information' : 'Renter Information';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Alinea verticalmente
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade700,
            child: Text(
              name.length >= 2 ? name.substring(0, 2).toUpperCase() : 'N/A',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido verticalmente
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    // <<<--- CORRECCIÓN AQUÍ ---<<<
                    // Flexible permite que este texto se encoja si es necesario.
                    Flexible(
                      child: Text(
                        '4.9 (127 reviews)',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                        overflow: TextOverflow.ellipsis, // Importante para cuando se encoje
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {},
            child: Text(isRenterView ? 'Message Owner' : 'Message Renter'),
          )
        ],
      ),
    );
  }
}