// lib/features/rentals/views/details_widgets/action_buttons.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/rentals/services/rental_services.dart';

class ActionButtons extends StatelessWidget {
  final RentalModel rental;
  final bool isRenterView;

  const ActionButtons({
    super.key,
    required this.rental,
    required this.isRenterView,
  });

  Future<bool?> _showConfirmationDialog(
      BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        // ✨ MEJORA: Estilo del diálogo consistente con el tema oscuro.
        backgroundColor: const Color(0xFF2C2C2E),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(content, style: const TextStyle(color: Colors.white70)),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: const Text('Confirmar', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final rentalService = context.read<RentalService>();
        return Container(
          padding: const EdgeInsets.all(16).copyWith(top: 12, bottom: 32),
          decoration: const BoxDecoration(
            color: Color(0xFF1C1C1E),
            border: Border(top: BorderSide(color: Color(0xFF3A3A3C), width: 0.5)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: isRenterView
                  ? _buildRenterButtons(context, rentalService)
                  : _buildOwnerButtons(context, rentalService),
            ),
          ),
        );
      },
    );
  }

  // --- Botones para el Arrendatario (Renter) ---
  List<Widget> _buildRenterButtons(BuildContext context, RentalService service) {
    // ✨ MEJORA: Estilo de botones consistente
    final buttonStyle = ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.bold));
    final outlinedButtonStyle = OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.grey),
        padding: const EdgeInsets.symmetric(vertical: 12));

    switch (rental.status) {
      case RentalStatus.awaiting_delivery:
        return [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              // ✨ MEJORA: Texto en español.
              label: const Text('Confirmar Recepción'),
              style: buttonStyle.copyWith(backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () async {
                final confirmed = await _showConfirmationDialog(
                    context,
                    'Confirmar Recepción',
                    '¿Estás seguro de que has recibido el producto en buenas condiciones?');
                if (confirmed == true) {
                  await service.confirmDelivery(rental.rentalId);
                  Navigator.pop(context, true);
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          // ✨ MEJORA: Texto en español.
          OutlinedButton(style: outlinedButtonStyle, onPressed: () {}, child: const Text('Soporte')),
        ];

      case RentalStatus.ongoing:
        return [
          // ✨ MEJORA: Texto en español.
          Expanded(child: ElevatedButton(style: buttonStyle, onPressed: () {}, child: const Text('Extender Alquiler'))),
          const SizedBox(width: 12),
          OutlinedButton(style: outlinedButtonStyle, onPressed: () {}, child: const Text('Contactar Soporte')),
        ];

      case RentalStatus.completed:
        if (!rental.reviewedByRenter) {
          return [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: buttonStyle.copyWith(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                // ✨ MEJORA: Texto en español.
                child: const Text('Dejar una Reseña'),
              ),
            ),
          ];
        }
        // ✨ MEJORA: Texto en español.
        return [Expanded(child: ElevatedButton(style: buttonStyle, onPressed: () {}, child: const Text('Ver Reseña')))];

      default:
      // ✨ MEJORA: Texto en español.
        return [Expanded(child: ElevatedButton(style: buttonStyle, onPressed: () {}, child: const Text('Contactar Soporte')))];
    }
  }

  // --- Botones para el Dueño (Owner) ---
  List<Widget> _buildOwnerButtons(BuildContext context, RentalService service) {
    final buttonStyle = ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.bold));
    final outlinedButtonStyle = OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.grey),
        padding: const EdgeInsets.symmetric(vertical: 12));

    switch (rental.status) {
      case RentalStatus.awaiting_delivery:
        return [
          // ✨ MEJORA: Texto en español.
          Expanded(child: ElevatedButton(style: buttonStyle, onPressed: () {}, child: const Text('Rastrear Envío'))),
          const SizedBox(width: 12),
          OutlinedButton(style: outlinedButtonStyle, onPressed: () {}, child: const Text('Contactar')),
        ];

      case RentalStatus.ongoing:
        return [
          Expanded(
            child: ElevatedButton(
              style: buttonStyle.copyWith(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
              onPressed: () async {
                final confirmed = await _showConfirmationDialog(
                  context,
                  'Confirmar Devolución',
                  '¿Confirmas que has recibido el producto de vuelta y está en buen estado? Esto completará el alquiler.',
                );
                if (confirmed == true) {
                  await service.completeRental(rental.rentalId);
                  Navigator.pop(context, true);
                }
              },
              // ✨ MEJORA: Texto en español.
              child: const Text('Marcar como Devuelto'),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton(style: outlinedButtonStyle, onPressed: () {}, child: const Text('Soporte')),
        ];

      case RentalStatus.completed:
        if (!rental.reviewedByOwner) {
          return [
            // ✨ MEJORA: Texto en español.
            Expanded(child: ElevatedButton(style: buttonStyle, onPressed: () {}, child: const Text('Dejar una Reseña'))),
          ];
        }
        // ✨ MEJORA: Texto en español.
        return [Expanded(child: ElevatedButton(style: buttonStyle, onPressed: () {}, child: const Text('Ver Reseña')))];

      default:
      // ✨ MEJORA: Texto en español.
        return [Expanded(child: ElevatedButton(style: buttonStyle, onPressed: () {}, child: const Text('Contactar Soporte')))];
    }
  }
}