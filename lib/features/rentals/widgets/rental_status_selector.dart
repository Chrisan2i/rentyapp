import 'package:flutter/material.dart';

class RentalStatusSelector extends StatelessWidget {
  final bool isOngoingSelected;
  final ValueChanged<bool> onStatusSelected;

  const RentalStatusSelector({Key? key, required this.isOngoingSelected, required this.onStatusSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildStatusButton('Ongoing', true),
        const SizedBox(width: 12),
        _buildStatusButton('Past', false),
      ],
    );
  }

  Widget _buildStatusButton(String label, bool representsOngoing) {
    final isSelected = isOngoingSelected == representsOngoing;
    return Material(
      color: isSelected ? const Color(0xFF0A84FF) : const Color(0xFF2C2C2E),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => onStatusSelected(representsOngoing),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade400,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}