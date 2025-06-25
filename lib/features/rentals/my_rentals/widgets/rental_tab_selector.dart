// lib/features/rentals/widgets/rental_tab_selector.dart

import 'package:flutter/material.dart';

class RentalTabSelector extends StatelessWidget {
  final String currentTab;
  final ValueChanged<String> onTabSelected;

  const RentalTabSelector({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // ✨ MEJORA: Textos traducidos a español.
          _buildTabButton('Como Arrendatario', 'renter'),
          _buildTabButton('Como Propietario', 'owner'),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, String tabType) {
    final bool isSelected = currentTab == tabType;
    return Expanded(
      child: Material(
        color: isSelected ? Colors.blueAccent : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => onTabSelected(tabType),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                // ✨ MEJORA: Mayor énfasis en el texto para mejor legibilidad.
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}