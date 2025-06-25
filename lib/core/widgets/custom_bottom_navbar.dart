// lib/features/navigation/custom_bottom_navbar.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/widgets/navbar_item.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: AppColors.surface,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // <<<--- CAMBIO: Textos traducidos al español ---<<<
            NavBarItem(
              icon: Icons.home_filled, // Icono relleno para el seleccionado
              label: 'Inicio',
              selected: selectedIndex == 0,
              onTap: () => onItemTapped(0),
            ),
            NavBarItem(
              icon: Icons.search,
              label: 'Buscar',
              selected: selectedIndex == 1,
              onTap: () => onItemTapped(1),
            ),
            const SizedBox(width: 40), // Espacio para el FloatingActionButton
            NavBarItem(
              icon: Icons.inbox_outlined, // Puedes usar diferentes íconos
              label: 'Alquileres',
              selected: selectedIndex == 2,
              onTap: () => onItemTapped(2),
            ),
            NavBarItem(
              icon: Icons.person_outline,
              label: 'Perfil',
              selected: selectedIndex == 3,
              onTap: () => onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}