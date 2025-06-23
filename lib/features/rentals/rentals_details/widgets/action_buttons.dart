// lib/features/rentals/views/details_widgets/action_buttons.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';

class ActionButtons extends StatelessWidget {
  final RentalModel rental;
  final bool isRenterView;
  const ActionButtons({super.key, required this.rental, required this.isRenterView});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(top: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        border: Border(top: BorderSide(color: Color(0xFF3A3A3C), width: 0.5)),
      ),
      child: SafeArea(
        child: Row(
          children: isRenterView
              ? _buildRenterButtons(context)
              : _buildOwnerButtons(context),
        ),
      ),
    );
  }

  List<Widget> _buildRenterButtons(BuildContext context) {
    if (rental.status == RentalStatus.ongoing) {
      return [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Extend Rental'),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton(onPressed: (){}, child: const Text('Contact Support')),
        const SizedBox(width: 12),
        OutlinedButton(onPressed: (){}, child: const Text('Leave Review')),
      ];
    }
    // Añade más lógica para otros estados aquí (completed, etc.)
    return [Expanded(child: ElevatedButton(onPressed: (){}, child: const Text('Contact Support')))];
  }

  List<Widget> _buildOwnerButtons(BuildContext context) {
    if (rental.status == RentalStatus.awaiting_delivery || rental.status == RentalStatus.ongoing) {
      return [
        Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('Track Item Location'))),
        const SizedBox(width: 12),
        OutlinedButton(onPressed: () {}, child: const Text('Contact Support')),
        if (rental.status == RentalStatus.ongoing) ...[
          const SizedBox(width: 12),
          OutlinedButton(onPressed: () {}, child: const Text('Mark Returned')),
        ]
      ];
    }
    // Añade más lógica para otros estados aquí
    return [Expanded(child: ElevatedButton(onPressed: (){}, child: const Text('Contact Support')))];
  }
}