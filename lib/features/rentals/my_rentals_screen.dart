import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/controllers/controller.dart'; // Import correcto
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/rentals/widgets/rental_card_widget.dart';
import 'widgets/rental_status_selector.dart';
import 'widgets/rental_tab_selector.dart';

class RentalView extends StatefulWidget {
  const RentalView({super.key});

  @override
  State<RentalView> createState() => _RentalViewState();
}

class _RentalViewState extends State<RentalView> {
  String _currentTab = 'renter'; // 'renter' o 'owner'
  bool _isOngoingSelected = true; // true para 'Ongoing', false para 'Past'

  /// Filtra la lista de alquileres basándose en las pestañas seleccionadas.
  List<RentalModel> _filterRentals(List<RentalModel> allRentals, String userId) {
    return allRentals.where((rental) {
      final bool isUserRenter = rental.renterInfo['userId'] == userId;
      final bool isUserOwner = rental.ownerInfo['userId'] == userId;

      if (_currentTab == 'renter' && !isUserRenter) return false;
      if (_currentTab == 'owner' && !isUserOwner) return false;

      final isOngoingStatus = rental.status == RentalStatus.ongoing ||
          rental.status == RentalStatus.awaiting_delivery;

      if (_isOngoingSelected) {
        return isOngoingStatus;
      } else {
        return !isOngoingStatus;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AppController>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'My Rentals',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(AppController controller) {
    switch (controller.rentalsState) {
      case ViewState.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );

      case ViewState.error:
        return const Center(
          child: Text(
            "Error loading rentals.",
            style: TextStyle(color: AppColors.danger),
          ),
        );

      case ViewState.idle:
        if (controller.currentUser == null) {
          return const Center(
            child: Text(
              "Please log in to see your rentals.",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        final filteredRentals = _filterRentals(
          controller.rentals,
          controller.currentUser!.userId,
        );

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RentalTabSelector(
                  currentTab: _currentTab,
                  onTabSelected: (tabType) =>
                      setState(() => _currentTab = tabType),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RentalStatusSelector(
                  isOngoingSelected: _isOngoingSelected,
                  onStatusSelected: (isOngoing) =>
                      setState(() => _isOngoingSelected = isOngoing),
                ),
              ),
              const SizedBox(height: 20),
              if (filteredRentals.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Text(
                      "No rentals found in this category.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredRentals.length,
                  itemBuilder: (context, index) {
                    return RentalCardWidget(
                      rental: filteredRentals[index],
                      currentTab: _currentTab,
                    );
                  },
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 16),
                ),
              const SizedBox(height: 40),
            ],
          ),
        );
    }
  }
}
