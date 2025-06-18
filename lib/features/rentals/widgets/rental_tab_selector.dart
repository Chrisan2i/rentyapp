// lib/features/rentals/widgets/rental_tab_selector.dart
import 'package:flutter/material.dart';

class RentalTabSelector extends StatelessWidget {
  final String currentTab;
  final ValueChanged<String> onTabSelected;

  const RentalTabSelector({Key? key, required this.currentTab, required this.onTabSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E), // Un gris más oscuro para el fondo
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTabButton('As Renter', 'renter'),
          _buildTabButton('As Owner', 'owner'),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, String tabType) {
    final bool isSelected = currentTab == tabType;
    return Expanded(
      child: Material(
        color: isSelected ? const Color(0xFF0A84FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => onTabSelected(tabType),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}