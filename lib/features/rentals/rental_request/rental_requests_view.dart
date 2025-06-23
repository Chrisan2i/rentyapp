// lib/features/rentals/rental_requests_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/controllers/controller.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/send_rental_request/models/rental_request_model.dart';
import 'package:rentyapp/features/rentals/services/rental_services.dart';
import 'widgets/rental_request_card.dart';

class RentalRequestsView extends StatefulWidget {
  const RentalRequestsView({super.key});

  @override
  State<RentalRequestsView> createState() => _RentalRequestsViewState();
}

class _RentalRequestsViewState extends State<RentalRequestsView> {
  // <<<--- CORRECCIÓN: Elimina la creación de una nueva instancia aquí ---<<<
  // final RentalService _rentalService = RentalService();

  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = Provider.of<AppController>(context, listen: false).currentUser?.userId;
  }

  @override
  Widget build(BuildContext context) {
    // <<<--- CORRECCIÓN: Obtén la instancia del servicio desde Provider ---<<<
    final rentalService = context.watch<RentalService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rental Requests'),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _currentUserId == null
          ? const Center(child: Text("Please log in to see your requests.", style: TextStyle(color: Colors.white)))
          : StreamBuilder<List<RentalRequestModel>>(
        // Usa la instancia del provider
        stream: rentalService.getRentalRequestsForOwner(_currentUserId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: AppColors.danger)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("You have no incoming rental requests.", style: TextStyle(color: Colors.white70)));
          }

          final requests = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              return RentalRequestCard(request: requests[index]);
            },
          );
        },
      ),
    );
  }
}