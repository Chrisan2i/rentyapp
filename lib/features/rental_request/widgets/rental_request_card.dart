// ARCHIVO: lib/features/rentals/widgets/rental_request_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';
import 'package:rentyapp/features/product/models/product_model.dart';
import 'package:rentyapp/features/send_rental_request/models/rental_request_model.dart';
import 'package:rentyapp/features/rentals/services/rental_services.dart';
import 'renter_profile_dialog.dart';

class RentalRequestCard extends StatefulWidget {
  final RentalRequestModel request;

  const RentalRequestCard({super.key, required this.request});

  @override
  State<RentalRequestCard> createState() => _RentalRequestCardState();
}

class _RentalRequestCardState extends State<RentalRequestCard> {
  final RentalService _rentalService = RentalService();
  late final Future<Map<String, dynamic>> _cardDataFuture;

  @override
  void initState() {
    super.initState();
    _cardDataFuture = _fetchCardData();
  }

  Future<Map<String, dynamic>> _fetchCardData() async {
    final results = await Future.wait([
      FirebaseFirestore.instance.collection('products').doc(widget.request.productId).get(),
      FirebaseFirestore.instance.collection('users').doc(widget.request.renterId).get(),
    ]);

    final productDoc = results[0] as DocumentSnapshot<Map<String, dynamic>>;
    final renterDoc = results[1] as DocumentSnapshot<Map<String, dynamic>>;

    if (!productDoc.exists || !renterDoc.exists) {
      throw Exception("Product or Renter not found for request ${widget.request.requestId}");
    }

    return {
      'product': ProductModel.fromMap(productDoc.data()!, productDoc.id),
      'renter': UserModel.fromMap(renterDoc.data()!, renterDoc.id),
    };
  }

  void _showRenterProfile(BuildContext context, UserModel renter) {
    showDialog(
      context: context,
      builder: (ctx) => RenterProfileDialog(
        renter: renter,
        onAccept: () {
          Navigator.of(ctx).pop();
          _acceptRequest();
        },
      ),
    );
  }

  void _acceptRequest() async {
    // <<<--- CORRECCIÓN 1: Se pasa el objeto completo 'request' ---<<<
    // El servicio necesita el objeto completo para crear el nuevo documento "rental".
    // La firma del método en tu servicio probablemente es: acceptRentalRequest(RentalRequestModel request)
    await _rentalService.acceptRentalRequest(widget.request);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Request Accepted!"),
        backgroundColor: Colors.green,
      ));
    }
  }

  void _declineRequest() async {
    // <<<--- CORRECCIÓN 2: Se pasa el ID de la solicitud (asumiendo que este método sí espera un String) ---<<<
    // Para rechazar, generalmente solo necesitas el ID para actualizar el estado del documento.
    // Si este también da error, cámbialo a `_rentalService.declineRentalRequest(widget.request);`
    await _rentalService.declineRentalRequest(widget.request.requestId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Request Declined."),
        backgroundColor: AppColors.danger,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _cardDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            color: AppColors.surface,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Card(
            color: AppColors.danger.withOpacity(0.2),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(title: Text('Error: ${snapshot.error}', style: const TextStyle(color: AppColors.danger))),
          );
        }

        final ProductModel product = snapshot.data!['product'];
        final UserModel renter = snapshot.data!['renter'];
        final DateFormat formatter = DateFormat('MMM d');
        final String dateRange = '${formatter.format(widget.request.startDate)} - ${formatter.format(widget.request.endDate)}';
        final double total = widget.request.financials['total'] ?? 0.0;

        return Card(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader(product, renter, dateRange),
                const SizedBox(height: 16),
                _buildCardFooter(total, renter),
                if (widget.request.status == 'pending')
                  _buildActionButtons(context, renter),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Widgets auxiliares para un build más limpio ---

  Widget _buildCardHeader(ProductModel product, UserModel renter, String dateRange) {
    return Row(
      children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: product.images.isNotEmpty ? DecorationImage(image: NetworkImage(product.images.first), fit: BoxFit.cover) : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Request from ${renter.fullName}', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
              Row(children: [
                Icon(Icons.calendar_today, color: Colors.grey[400], size: 14),
                const SizedBox(width: 6),
                Text(dateRange, style: TextStyle(color: Colors.grey[400], fontSize: 13)),
              ]),
            ],
          ),
        ),
        if (widget.request.status != 'pending') _buildStatusChip(widget.request.status),
      ],
    );
  }

  Widget _buildCardFooter(double total, UserModel renter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('\$${total.toStringAsFixed(0)} total', style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold)),
        Text('${renter.rating.toStringAsFixed(1)} ★ • ${renter.totalRentsAsRenter} rentals', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, UserModel renter) {
    return Column(
      children: [
        const Divider(color: Colors.white12, height: 32),
        Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: () => _showRenterProfile(context, renter), child: const Text('View Profile'), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white38)))),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(onPressed: _acceptRequest, child: const Text('Accept'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white))),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(width: double.infinity, child: TextButton(onPressed: _declineRequest, child: const Text('Decline'), style: TextButton.styleFrom(foregroundColor: AppColors.danger))),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = status == 'accepted' ? Colors.green : (status == 'declined' ? AppColors.danger : Colors.grey);
    String text = status.substring(0, 1).toUpperCase() + status.substring(1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}