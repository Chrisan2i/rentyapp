// lib/features/rentals/views/details_widgets/party_info_card.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';

class PartyInfoCard extends StatelessWidget {
  final RentalModel rental;
  final bool isRenterView;

  const PartyInfoCard({super.key, required this.rental, required this.isRenterView});

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0].substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final info = isRenterView ? rental.ownerInfo : rental.renterInfo;
    final name = info['fullName'] ?? (isRenterView ? 'Propietario' : 'Arrendatario');
    // ✨ MEJORA: Textos en español
    final title = isRenterView ? 'Información del Propietario' : 'Información del Arrendatario';
    final buttonText = isRenterView ? 'Contactar' : 'Contactar';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            // ✨ MEJORA: Color más sutil y consistente
            backgroundColor: Colors.grey.shade800,
            child: Text(
              _getInitials(name),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                const SizedBox(height: 2),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Flexible(
                      // ✨ MEJORA: Texto en español
                      child: Text('4.9 (127 reseñas)', style: TextStyle(color: Colors.grey.shade400, fontSize: 12), overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // ✨ MEJORA: Botón con un estilo más sutil
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.grey),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {},
            child: Text(buttonText),
          )
        ],
      ),
    );
  }
}