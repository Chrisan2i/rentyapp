// lib/features/rentals/rental_card_widget.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear las fechas
import 'package:rentyapp/features/rentals/models/rental_model.dart';

class RentalCardWidget extends StatelessWidget {
  final RentalModel rental;
  final String currentTab;

  // Add Key? key and make the constructor const
  const RentalCardWidget({Key? key, required this.rental, required this.currentTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDateInfo;
    Color statusButtonColor;

    if (rental.status == 'Ongoing') {
      formattedDateInfo = 'Due: ${DateFormat('MMM dd').format(rental.endDate)}';
      statusButtonColor = const Color(0xFF0085FF); // Blue for Ongoing
    } else if (rental.status == 'Completed') {
      formattedDateInfo = 'Completed: ${DateFormat('MMM dd').format(rental.endDate)}';
      statusButtonColor = const Color(0xFF333333); // Grey for Completed
    } else {
      formattedDateInfo = 'Start: ${DateFormat('MMM dd').format(rental.startDate)} - End: ${DateFormat('MMM dd').format(rental.endDate)}';
      statusButtonColor = const Color(0xFF333333);
    }

    String rentalRelationshipText;
    if (currentTab == 'renter') {
      rentalRelationshipText = 'You rented from ${rental.ownerId}';
    } else {
      rentalRelationshipText = 'You rented to ${rental.renterId}';
    }

    return Card(
      color: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://placehold.co/80x80',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rental.itemId,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rentalRelationshipText,
                    style: const TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formattedDateInfo,
                    style: const TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${rental.totalPrice}',
                    style: const TextStyle(
                      color: Color(0xFF0085FF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Acción para el botón de estado
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: Size(80, 30),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    rental.status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 8),
                if (currentTab == 'renter') ...[
                  if (rental.status == 'Ongoing')
                    ElevatedButton(
                      onPressed: () {
                        // Acción para contactar al dueño
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF333333),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(80, 30),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Contact Owner',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  else if (rental.status == 'Completed' && !rental.reviewedByRenter)
                    ElevatedButton(
                      onPressed: () {
                        // Acción para dejar reseña como renter
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF333333),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(80, 30),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Leave Review',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                ] else if (currentTab == 'owner') ...[
                  if (rental.status == 'Ongoing')
                    ElevatedButton(
                      onPressed: () {
                        // Acción para contactar al renter
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF333333),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(80, 30),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Contact Renter',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  else if (rental.status == 'Completed' && !rental.reviewedByOwner)
                    ElevatedButton(
                      onPressed: () {
                        // Acción para dejar reseña como owner
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF333333),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(80, 30),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Review Renter',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                ],
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Acción para ver detalles
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF333333),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(80, 30),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}