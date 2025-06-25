// lib/features/rentals/widgets/rental_status_selector.dart

import 'package:flutter/material.dart';

class RentalStatusSelector extends StatelessWidget {
  final bool isOngoingSelected;
  final ValueChanged<bool> onStatusSelected;

  const RentalStatusSelector({
    super.key,
    required this.isOngoingSelected,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // ✨ MEJORA: Textos traducidos a español.
        _buildStatusButton('En Curso', true),
        const SizedBox(width: 12),
        _buildStatusButton('Pasados', false),
      ],
    );
  }

  Widget _buildStatusButton(String label, bool representsOngoing) {
    final isSelected = isOngoingSelected == representsOngoing;
    return Material(
      color: isSelected ? Colors.blueAccent : const Color(0xFF2C2C2E),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => onStatusSelected(representsOngoing),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Text(
            label,
            style: TextStyle(
              // ✨ MEJORA: El color no seleccionado tiene mejor contraste.
              color: isSelected ? Colors.white : Colors.grey.shade300,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}