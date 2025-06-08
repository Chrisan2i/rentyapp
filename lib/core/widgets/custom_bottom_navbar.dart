import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/profile/profile_view.dart';
import 'package:rentyapp/features/landing/landing.dart';
import 'navbar_item.dart';

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
            NavBarItem(
              icon: Icons.home,
              label: 'Home',
              selected: selectedIndex == 0,
              onTap: () => onItemTapped(0),
            ),
            NavBarItem(
              icon: Icons.search,
              label: 'Search',
              selected: selectedIndex == 1,
              onTap: () => onItemTapped(1),
            ),
            const SizedBox(width: 40),
            NavBarItem(
              icon: Icons.inbox,
              label: 'Requests',
              selected: selectedIndex == 2,
              onTap: () => onItemTapped(2),
            ),
            NavBarItem(
              icon: Icons.person,
              label: 'Profile',
              selected: selectedIndex == 3,
              onTap: () => onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }

}
