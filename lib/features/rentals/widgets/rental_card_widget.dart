// lib/features/rentals/widgets/rental_card_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';

class RentalCardWidget extends StatelessWidget {
  final RentalModel rental;
  final String currentTab;

  const RentalCardWidget({
    Key? key,
    required this.rental,
    required this.currentTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E), // Color de la tarjeta como en la imagen
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemImage(),
          const SizedBox(width: 16),
          Expanded(child: _buildInfoColumn()),
          const SizedBox(width: 8),
          _buildActionsColumn(context),
        ],
      ),
    );
  }

  Widget _buildItemImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.network(
        rental.itemImageUrl,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: 72,
            height: 72,
            color: Colors.grey.shade800,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey.shade600)),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Text(
                rental.itemName.length > 4 ? rental.itemName.substring(0, 4) : rental.itemName,
                style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoColumn() {
    final isOngoing = rental.status == RentalStatus.ongoing || rental.status == RentalStatus.late;
    final datePrefix = isOngoing ? 'Due: ' : 'Completed: ';
    final formattedDate = DateFormat('MMM dd').format(rental.endDate);
    final relationshipText = currentTab == 'renter'
        ? 'You rented from ${rental.ownerName}'
        : 'Rented by ${rental.renterName}';

    return SizedBox(
      height: 72,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            rental.itemName,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Icon(Icons.person_outline, color: Colors.grey.shade500, size: 14),
              const SizedBox(width: 4),
              Text(relationshipText, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
            ],
          ),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: Colors.grey.shade500, size: 14),
              const SizedBox(width: 4),
              Text('$datePrefix$formattedDate', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
            ],
          ),
          Text(
            '\$${rental.totalPrice.toInt()} total',
            style: const TextStyle(color: Color(0xFF0A84FF), fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsColumn(BuildContext context) {

    return SizedBox(
      width: 105,
      height: 72,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatusTag(),
          ..._buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildStatusTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: rental.status.displayColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        rental.status.displayName,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    final bool isOngoing = rental.status == RentalStatus.ongoing || rental.status == RentalStatus.late;

    if (currentTab == 'renter') {
      if (isOngoing) {
        return [
          _buildActionButton(text: 'Contact Owner', onPressed: () {}, context: context),
          const SizedBox(height: 4),
          _buildActionButton(text: 'View Details', onPressed: () {}, context: context, isSecondary: true),
        ];
      } else { // Past
        if (rental.reviewedByRenter) {
          return [_buildActionButton(text: 'Review Left', onPressed: null, context: context)];
        } else {
          return [_buildActionButton(text: 'Leave Review', onPressed: () {}, context: context, color: const Color(0xFF34C759))];
        }
      }
    } else { // Owner
      if (isOngoing) {
        return [
          _buildActionButton(text: 'Contact Renter', onPressed: () {}, context: context),
          const SizedBox(height: 4),
          _buildActionButton(text: 'View Details', onPressed: () {}, context: context, isSecondary: true),
        ];
      } else { // Past
        if (rental.reviewedByOwner) {
          return [
            _buildActionButton(text: 'View Review', onPressed: () {}, context: context, color: const Color(0xFF0A84FF)),
            const SizedBox(height: 4),
            _buildActionButton(text: 'Report Issue', onPressed: () {}, context: context, color: const Color(0xFFFF3B30)),
          ];
        } else {
          return [
            _buildActionButton(text: 'No Review', onPressed: null, context: context),
            const SizedBox(height: 4),
            _buildActionButton(text: 'Report Issue', onPressed: () {}, context: context, color: const Color(0xFFFF3B30)),
          ];
        }
      }
    }
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback? onPressed,
    required BuildContext context,
    Color? color,
    bool isSecondary = false,
  }) {
    final bool isEnabled = onPressed != null;
    final Color enabledColor = color ?? (isSecondary ? const Color(0xFF3A3A3C) : const Color(0xFF48484A));
    final Color disabledColor = const Color(0xFF3A3A3C);

    return SizedBox(
      width: double.infinity,
      height: 28,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? enabledColor : disabledColor,
          foregroundColor: isEnabled ? Colors.white : Colors.grey.shade600,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}