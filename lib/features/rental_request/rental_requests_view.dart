import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/send_rental_request/models/rental_request_model.dart';
import 'package:rentyapp/features/rentals/services/rental_services.dart';
import 'widgets/rental_request_card.dart';

class RentalRequestsView extends StatefulWidget {
  const RentalRequestsView({Key? key}) : super(key: key);

  @override
  State<RentalRequestsView> createState() => _RentalRequestsViewState();
}

class _RentalRequestsViewState extends State<RentalRequestsView> {
  final RentalService _rentalService = RentalService();
  final String? _currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rental Requests'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () { /* TODO: Implementar filtro */ },
            icon: const Icon(Icons.filter_list_rounded, color: AppColors.primary),
          ),
        ],
      ),
      body: _currentUserId == null
          ? const Center(child: Text("Please log in to see your requests.", style: TextStyle(color: Colors.white)))
          : StreamBuilder<List<RentalRequestModel>>(
        stream: _rentalService.getRentalRequestsForOwner(_currentUserId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: AppColors.error)));
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