import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class QuickAccessRow extends StatelessWidget {
  const QuickAccessRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _QuickAccessItem(icon: Icons.build, label: 'Tools'),
        _QuickAccessItem(icon: Icons.electrical_services, label: 'Gadgets'),
        _QuickAccessItem(icon: Icons.directions_car, label: 'Vehicles'),
      ],
    );
  }
}

class _QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickAccessItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.card,
          child: Icon(icon, color: AppColors.white),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.quickAccessLabel),
      ],
    );
  }
}
