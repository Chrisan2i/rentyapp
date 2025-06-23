// lib/features/rentals/views/rental_details_screen.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';

// Importa los nuevos widgets separados
import 'widgets/action_buttons.dart';
import 'widgets/financials_breakdown_card.dart';
import 'widgets/party_info_card.dart';
import 'widgets/product_summary_card.dart';
import 'widgets/rental_info_section.dart';
import 'widgets/rental_timeline_widget.dart';

class RentalDetailsScreen extends StatelessWidget {
  final RentalModel rental;
  final String viewerRole; // 'renter' o 'owner'

  const RentalDetailsScreen({
    super.key,
    required this.rental,
    required this.viewerRole,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRenterView = viewerRole == 'renter';

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Rental Details', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () { /* TODO: Implementar lógica para compartir */ },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Usa los widgets públicos importados
            ProductSummaryCard(rental: rental, isRenterView: isRenterView),
            const SizedBox(height: 16),
            PartyInfoCard(rental: rental, isRenterView: isRenterView),
            const SizedBox(height: 16),
            RentalInfoSection(rental: rental),
            const SizedBox(height: 16),
            FinancialsBreakdownCard(rental: rental, isRenterView: isRenterView),
            const SizedBox(height: 16),
            if (!isRenterView) RentalTimelineWidget(rental: rental),
          ],
        ),
      ),
      bottomNavigationBar: ActionButtons(rental: rental, isRenterView: isRenterView),
    );
  }
}