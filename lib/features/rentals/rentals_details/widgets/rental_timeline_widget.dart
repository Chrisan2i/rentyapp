// lib/features/rentals/views/details_widgets/rental_timeline_widget.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';

class RentalTimelineWidget extends StatelessWidget {
  final RentalModel rental;
  const RentalTimelineWidget({super.key, required this.rental});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rental Timeline', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _TimelineStep(
            title: 'Request Received',
            subtitle: DateFormat('MMM d, yyyy \'at\' hh:mm a').format(rental.createdAt),
            isCompleted: true,
          ),
          _TimelineStep(
            title: 'Request Approved',
            subtitle: DateFormat('MMM d, yyyy \'at\' hh:mm a').format(rental.createdAt.add(const Duration(minutes: 5))),
            isCompleted: true,
          ),
          _TimelineStep(
            title: 'Payment Confirmed',
            subtitle: rental.status != RentalStatus.awaiting_payment ? 'Payment done' : 'Pending...',
            isCompleted: rental.status != RentalStatus.awaiting_payment,
          ),
          _TimelineStep(
            title: 'Item Delivered',
            isCompleted: rental.status == RentalStatus.ongoing || rental.status == RentalStatus.completed,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isCompleted;
  final bool isLast;

  const _TimelineStep({
    required this.title,
    this.subtitle,
    this.isCompleted = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? const Color(0xFF34C759) : Colors.grey.shade600,
              size: 20,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: isCompleted ? const Color(0xFF34C759) : Colors.grey.shade600,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: isCompleted ? Colors.white : Colors.grey.shade500, fontWeight: FontWeight.bold)),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(subtitle!, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ),
          ],
        )
      ],
    );
  }
}