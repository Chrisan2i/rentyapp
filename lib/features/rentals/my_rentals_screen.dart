import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

import 'package:rentyapp/features/rentals/widgets/rental_card_widget.dart';
import 'widgets/rental_status_selector.dart';
import 'package:rentyapp/features/rentals/widgets/rental_tab_selector.dart';

import 'package:rentyapp/core/controllers/controller.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';

class RentalView extends StatefulWidget {
  const RentalView({super.key});

  @override
  State<RentalView> createState() => _RentalViewState();
}

class _RentalViewState extends State<RentalView> {
  String _currentTab = 'renter';
  bool _isOngoingSelected = true;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    final user = controller.currentUser;
    List<RentalModel> allRentals = controller.rentals;

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


    final filteredRentals = allRentals.where((rental) {
      final bool isUserRenter = rental.renterId == user.userId;
      final bool isUserOwner = rental.ownerId == user.userId;


      if (_currentTab == 'renter' && !isUserRenter) return false;
      if (_currentTab == 'owner' && !isUserOwner) return false;

      // Filtrar por estado (Ongoing / Past)
      final isOngoingStatus = rental.status == RentalStatus.ongoing || rental.status == RentalStatus.late;
      final isPastStatus = rental.status == RentalStatus.completed || rental.status == RentalStatus.cancelled;

      if (_isOngoingSelected && !isOngoingStatus) return false;
      if (!_isOngoingSelected && !isPastStatus) return false;

      return true;
    }).toList();


    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Rentals',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            // El icono en la imagen se parece más a un funnel o filtro.
            icon: const Icon(Icons.filter_list, color: Colors.white, size: 24),
            onPressed: () {
              // TODO: Implement filter functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredRentals.length,
              itemBuilder: (context, index) {
                final rental = filteredRentals[index];
                return RentalCardWidget(rental: rental, currentTab: _currentTab);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}