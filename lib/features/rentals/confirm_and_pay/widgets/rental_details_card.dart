// lib/features/rentals/views/widgets/rental_details_card.dart

import 'package:flutter/material.dart';
import '../../models/rental_model.dart';
import 'package:rentyapp/core/widgets/info_card.dart'; // Asegúrate que la ruta sea correcta

class RentalDetailsCard extends StatelessWidget {
  final RentalModel rental;

  const RentalDetailsCard({super.key, required this.rental});

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    return name.split(' ').map((e) => e[0]).take(2).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final owner = rental.ownerInfo;
    final pickupLocation = rental.productInfo['pickupLocation'] ?? {};
    final String ownerName = owner['fullName'] ?? 'Propietario';

    return InfoCard( // ✨ MEJORA: Reutilizando el InfoCard centralizado.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // ✨ MEJORA: Texto en español.
            'Detalles del Alquiler',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Text(_getInitials(ownerName),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // ✨ MEJORA: Texto en español.
                    'Alquilas a',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.grey.shade400),
                  ),
                  Text(ownerName,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: Colors.white)),
                ],
              ),
              const Spacer(),
              TextButton(
                  onPressed: () {},
                  // ✨ MEJORA: Texto en español.
                  child: const Text('Ver Perfil'))
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            // ✨ MEJORA: Colores más consistentes con un tema oscuro.
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // ✨ MEJORA: Texto en español.
                  'Lugar de Recogida',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey.shade400),
                ),
                const SizedBox(height: 4),
                Text(
                    pickupLocation['name'] ??
                        'Estudio de Fotografía Central',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: Colors.white)),
                const SizedBox(height: 2),
                Text(
                    pickupLocation['address'] ??
                        'Av. Principal 123, San Francisco, CA',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.grey.shade400)),
              ],
            ),
          )
        ],
      ),
    );
  }
}