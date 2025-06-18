import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';
import 'package:rentyapp/features/product/models/product_model.dart';
import 'package:rentyapp/features/send_rental_request/models/rental_request_model.dart';
import 'package:rentyapp/features/rentals/services/rental_services.dart';
import 'renter_profile_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RentalRequestCard extends StatefulWidget {
  final RentalRequestModel request;

  const RentalRequestCard({Key? key, required this.request}) : super(key: key);

  @override
  State<RentalRequestCard> createState() => _RentalRequestCardState();
}

class _RentalRequestCardState extends State<RentalRequestCard> {
  final RentalService _rentalService = RentalService();
  Future<Map<String, dynamic>>? _cardDataFuture;

  @override
  void initState() {
    super.initState();
    _cardDataFuture = _fetchCardData();
  }

  Future<Map<String, dynamic>> _fetchCardData() async {
    final productDoc = await FirebaseFirestore.instance.collection('products').doc(widget.request.productId).get();
    final renterDoc = await FirebaseFirestore.instance.collection('users').doc(widget.request.renterId).get();
    return {
      'product': ProductModel.fromFirestore(productDoc),
      'renter': UserModel.fromMap(renterDoc.data()!),
    };
  }

  void _showRenterProfile(BuildContext context, UserModel renter) {
    showDialog(
      context: context,
      builder: (context) => RenterProfileDialog(
        renter: renter,
        onAccept: () {
          Navigator.of(context).pop(); // Cierra el dialogo
          _acceptRequest();
        },
      ),
    );
  }

  void _acceptRequest() async {
    await _rentalService.acceptRentalRequest(widget.request);
    // El StreamBuilder en la pantalla principal se encargará de actualizar la UI
  }

  void _declineRequest() async {
    await _rentalService.declineRentalRequest(widget.request.requestId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _cardDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(child: Center(child: CircularProgressIndicator()));
        }
        if (!snapshot.hasData) {
          return const Card(child: ListTile(title: Text('Error loading data...')));
        }

        final ProductModel product = snapshot.data!['product'];
        final UserModel renter = snapshot.data!['renter'];
        final DateFormat formatter = DateFormat('MMM d');
        final String dateRange = '${formatter.format(widget.request.startDate.toDate())} - ${formatter.format(widget.request.endDate.toDate())}';

        return Card(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(8),
                        image: product.images.isNotEmpty
                            ? DecorationImage(image: NetworkImage(product.images.first), fit: BoxFit.cover)
                            : null,
                      ),
                      child: product.images.isEmpty
                          ? const Icon(Icons.inventory_2_outlined, color: Colors.grey, size: 30)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.title, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              CircleAvatar(radius: 12, child: Text(renter.fullName[0])),
                              const SizedBox(width: 8),
                              Text('Request from ${renter.fullName}', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.grey[400], size: 14),
                              const SizedBox(width: 6),
                              Text(dateRange, style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (widget.request.status != 'pending')
                      _buildStatusChip(widget.request.status),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${widget.request.total.toStringAsFixed(0)} total', style: TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text('${renter.rating.toStringAsFixed(1)} • ${renter.totalRentsReceived} rentals', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                      ],
                    ),
                  ],
                ),
                if (widget.request.status == 'pending') ...[
                  const Divider(color: Colors.white12, height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showRenterProfile(context, renter),
                          child: const Text('View Profile'),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white38)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _acceptRequest,
                          child: const Text('Accept'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _declineRequest,
                      child: const Text('Decline'),
                      style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                    ),
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = status == 'accepted' ? Colors.green : AppColors.danger;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.substring(0, 1).toUpperCase() + status.substring(1),
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}