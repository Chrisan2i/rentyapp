// lib/features/rentals/rental_status_selector.dart
import 'package:flutter/material.dart';

class RentalStatusSelector extends StatelessWidget {
  final bool isOngoingSelected; // Para manejar qué estado está seleccionado
  final ValueChanged<bool> onStatusSelected; // Callback para notificar el cambio de estado

  RentalStatusSelector({required this.isOngoingSelected, required this.onStatusSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(4), // Padding around the buttons
      decoration: BoxDecoration(
        color: Color(0xFF333333), // Dark grey background for the selector
        borderRadius: BorderRadius.circular(10), // Rounded corners for the container
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatusButton('Ongoing', true, isOngoingSelected),
          _buildStatusButton('Past', false, !isOngoingSelected),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String label, bool representsOngoing, bool isSelected) {
    return Expanded( // Use Expanded to make buttons take equal space
      child: GestureDetector(
        onTap: () => onStatusSelected(representsOngoing), // Llama al callback al seleccionar
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent, // Blue when selected, transparent otherwise
            borderRadius: BorderRadius.circular(8), // Slightly rounded corners for the button itself
          ),
          child: Text(
            label,
            textAlign: TextAlign.center, // Center the text
            style: TextStyle(
              color: Colors.white, // Text color is always white
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}