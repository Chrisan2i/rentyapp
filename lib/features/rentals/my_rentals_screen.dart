// lib/features/rentals/rental_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

import 'package:rentyapp/features/rentals/widgets/rental_card_widget.dart';
import 'package:rentyapp/features/rentals/widgets/rental_status_selector.dart';
import 'package:rentyapp/features/rentals/widgets/rental_tab_selector.dart';

import 'package:rentyapp/core/controllers/controller.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';

class RentalView extends StatefulWidget {
  const RentalView({super.key});

  @override
  State<RentalView> createState() => _RentalViewState();
}

class _RentalViewState extends State<RentalView> {
  String _currentTab = 'renter'; // Estado local para la pestaña seleccionada
  bool _isOngoingSelected = true; // Estado local para el filtro de estado

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    final user = controller.currentUser;
    List<RentalModel> rentals = controller.rentals;

    if (controller.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text("No user data found", style: AppTextStyles.subtitle),
        ),
      );
    }

    rentals = rentals.where((rental) {
      bool matchesTab = false;
      if (_currentTab == 'renter') {
        matchesTab = rental.renterId == user.userId;
      } else {
        matchesTab = rental.ownerId == user.userId;
      }

      if (!matchesTab) {
        return false;
      }

      if (_isOngoingSelected) {
        return rental.status == 'Ongoing';
      } else {
        return rental.status == 'Completed';
      }
    }).toList();


    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar( // Added AppBar here
        backgroundColor: AppColors.background, // Set background color to match the scaffold
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white), // Back arrow icon
          onPressed: () {
            // Implement navigation back functionality here
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'My Rentals',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // Based on the screenshot
            fontSize: 18,
          ),
        ),
        centerTitle: true, // Center the title as seen in the screenshot
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white), // Filter icon
            onPressed: () {
              // Implement filter functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            // The SizedBox(height: 60) directly under the AppBar is no longer needed if AppBar handles top padding
            // But if you want space below the AppBar, you can keep a smaller SizedBox
            // const SizedBox(height: 60), // Removed as AppBar handles top space
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: RentalTabSelector(
                currentTab: _currentTab,
                onTabSelected: (tabType) {
                  setState(() {
                    _currentTab = tabType;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: RentalStatusSelector(
                isOngoingSelected: _isOngoingSelected,
                onStatusSelected: (isOngoing) {
                  setState(() {
                    _isOngoingSelected = isOngoing;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: rentals.length,
              itemBuilder: (context, index) {
                final rental = rentals[index];
                return RentalCardWidget(rental: rental, currentTab: _currentTab);
              },
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}