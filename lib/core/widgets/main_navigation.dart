import 'package:flutter/material.dart';
import 'package:rentyapp/features/landing/landing.dart';
import 'package:rentyapp/features/profile/profile_view.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'custom_bottom_navbar.dart';
import 'package:rentyapp/features/add_product/view/add_product_view.dart';
import 'package:rentyapp/features/rentals/my_rentals/my_rentals_screen.dart';
import 'package:rentyapp/features/search/search_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    LandingPage(),
    SearchScreen(),
    RentalView(),
    ProfileView()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 8,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductView()),
          );
        },
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
