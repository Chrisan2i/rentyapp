// lib/features/rentals/rental_tab_selector.dart
import 'package:flutter/material.dart';

class RentalTabSelector extends StatelessWidget {
  final String currentTab;
  final ValueChanged<String> onTabSelected; // Callback para notificar el cambio de pestaña

  RentalTabSelector({required this.currentTab, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4), // Padding around the buttons
      decoration: BoxDecoration(
        color: Color(0xFF333333), // Dark grey background for the selector
        borderRadius: BorderRadius.circular(10), // Rounded corners for the container
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTabButton('As Renter', currentTab == 'renter', 'renter'),
          _buildTabButton('As Owner', currentTab == 'owner', 'owner'),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, bool isSelected, String tabType) {
    return Expanded( // Use Expanded to make buttons take equal space
      child: GestureDetector(
        onTap: () => onTabSelected(tabType), // Llama al callback al seleccionar
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