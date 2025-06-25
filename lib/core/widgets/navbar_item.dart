// lib/features/navigation/navbar_item.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const NavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.white70;
    final style = selected ? AppTextStyles.navBarLabelSelected : AppTextStyles.navBarLabel;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // Mejora el área de toque
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 2), // Un pequeño espacio mejora la legibilidad
          Text(label, style: style),
        ],
      ),
    );
  }
}