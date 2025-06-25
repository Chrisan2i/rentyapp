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
        // ✨ MEJORA: Texto en español
        title: const Text('Detalles del Alquiler', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () { /* TODO: Implement share logic */ },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Los widgets importados reflejarán automáticamente las mejoras
            ProductSummaryCard(rental: rental, isRenterView: isRenterView),
            const SizedBox(height: 16),
            PartyInfoCard(rental: rental, isRenterView: isRenterView),
            const SizedBox(height: 16),
            RentalInfoSection(rental: rental),
            const SizedBox(height: 16),
            FinancialsBreakdownCard(rental: rental, isRenterView: isRenterView),
            const SizedBox(height: 16),
            // La línea de tiempo solo se muestra para el dueño (owner)
            if (!isRenterView) ...[
              RentalTimelineWidget(rental: rental),
              const SizedBox(height: 16),
            ],
            // ✨ MEJORA: Espacio extra al final para que no se pegue al bottom bar.
            const SizedBox(height: 16),
          ],
        ),
      ),
      // La barra de acciones ya está modularizada y mejorada
      bottomNavigationBar: ActionButtons(rental: rental, isRenterView: isRenterView),
    );
  }
}