// lib/features/rentals/widgets/rental_card_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
// <<<--- 1. IMPORTACIÓN AÑADIDA ---<<<
import 'package:rentyapp/features/rentals/rentals_details/rental_details_view.dart';

// --- Extensión para el Enum RentalStatus ---
extension RentalStatusExtension on RentalStatus {
  String get displayName {
    switch (this) {
      case RentalStatus.awaiting_payment:
        return 'Awaiting Payment';
      case RentalStatus.awaiting_delivery:
        return 'Awaiting Delivery';
      case RentalStatus.ongoing:
        return 'Ongoing';
      case RentalStatus.completed:
        return 'Completed';
      case RentalStatus.cancelled:
        return 'Cancelled';
      case RentalStatus.disputed:
        return 'Disputed';
    }
  }

  Color get displayColor {
    switch (this) {
      case RentalStatus.awaiting_payment:
        return Colors.blue.shade600;
      case RentalStatus.awaiting_delivery:
        return Colors.orange.shade700;
      case RentalStatus.ongoing:
        return const Color(0xFF0A84FF);
      case RentalStatus.completed:
        return const Color(0xFF34C759);
      case RentalStatus.cancelled:
        return Colors.grey.shade600;
      case RentalStatus.disputed:
        return const Color(0xFFFF3B30);
    }
  }
}

class RentalCardWidget extends StatelessWidget {
  final RentalModel rental;
  final String currentTab;
  final Function(RentalModel rental) onPayNowPressed;

  const RentalCardWidget({
    Key? key,
    required this.rental,
    required this.currentTab,
    required this.onPayNowPressed,
  }) : super(key: key);

  // <<<--- 2. FUNCIÓN DE NAVEGACIÓN AÑADIDA ---<<<
  /// Navega a la pantalla de detalles del alquiler.
  void _navigateToDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RentalDetailsScreen(
          rental: rental,
          viewerRole: currentTab, // Pasa el rol actual del usuario
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetails(context), // Permite tocar toda la tarjeta para ver detalles
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
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
      ),
    );
  }

  Widget _buildItemImage() {
    final imageUrl = rental.productInfo['imageUrl'] as String?;
    final title = rental.productInfo['title'] as String? ?? 'N/A';
    final bool hasValidUrl = imageUrl != null && imageUrl.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: hasValidUrl
          ? Image.network(
        imageUrl,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: 72,
            height: 72,
            color: Colors.grey.shade800,
            child: Center(
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.grey.shade600)),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage(title);
        },
      )
          : _buildFallbackImage(title),
    );
  }

  Widget _buildFallbackImage(String title) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Text(
          title.isNotEmpty
              ? title.substring(0, title.length > 4 ? 4 : title.length)
              : 'N/A',
          style: const TextStyle(
              color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildInfoColumn() {
    final isOngoing = rental.status == RentalStatus.ongoing ||
        rental.status == RentalStatus.awaiting_delivery;
    final datePrefix = isOngoing ? 'Due: ' : 'Completed: ';
    final formattedDate = DateFormat('MMM dd').format(rental.endDate);
    final ownerName = rental.ownerInfo['fullName'] as String? ?? 'Owner';
    final renterName = rental.renterInfo['fullName'] as String? ?? 'Renter';
    final relationshipText =
    currentTab == 'renter' ? 'From $ownerName' : 'By $renterName';
    final itemTitle =
        rental.productInfo['title'] as String? ?? 'Untitled Product';
    final total = rental.financials['total'] ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          itemTitle,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.person_outline, color: Colors.grey.shade500, size: 14),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                relationshipText,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                color: Colors.grey.shade500, size: 14),
            const SizedBox(width: 4),
            Text('$datePrefix$formattedDate',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '\$${total.toStringAsFixed(2)} total',
          style: const TextStyle(
              color: Color(0xFF0A84FF),
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildActionsColumn(BuildContext context) {
    return SizedBox(
      width: 105,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatusTag(),
          const SizedBox(height: 8),
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
        style: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    );
  }

  // <<<--- 3. LÓGICA DE BOTONES ACTUALIZADA ---<<<
  List<Widget> _buildActionButtons(BuildContext context) {
    // Definimos un botón de detalles estándar para reutilizar.
    final viewDetailsButton = _buildActionButton(
      text: 'View Details',
      onPressed: () => _navigateToDetails(context),
      context: context,
    );
    final viewDetailsButtonSecondary = _buildActionButton(
      text: 'View Details',
      onPressed: () => _navigateToDetails(context),
      context: context,
      isSecondary: true,
    );

    // Simplificamos la lógica. La mayoría de los casos llevan a "View Details".
    // Casos especiales (como "Pay Now") se manejan por separado.

    if (currentTab == 'renter') {
      switch (rental.status) {
        case RentalStatus.awaiting_payment:
          return [
            _buildActionButton(
              text: 'Pay Now',
              onPressed: () => onPayNowPressed(rental),
              context: context,
              color: Colors.green.shade600,
            ),
          ];
        case RentalStatus.completed:
          if (!rental.reviewedByRenter) {
            return [
              _buildActionButton(
                text: 'Leave Review',
                onPressed: () {
                  _navigateToDetails(context); // Puede llevar a detalles para luego dejar reseña
                },
                context: context,
                color: const Color(0xFF34C759),
              )
            ];
          }
          return [viewDetailsButtonSecondary]; // Si ya dejó reseña
        case RentalStatus.ongoing:
        case RentalStatus.awaiting_delivery:
          return [viewDetailsButton]; // Botón principal
        default:
          return [viewDetailsButtonSecondary]; // Para 'cancelled', 'disputed', etc.
      }
    } else { // currentTab == 'owner'
      switch (rental.status) {
        case RentalStatus.completed:
        case RentalStatus.disputed:
          if (!rental.reviewedByOwner) { // Asumiendo que existe este campo
            return [
              _buildActionButton(
                text: 'View Details', // Podría ser 'Leave Review' o 'Resolve Issue'
                onPressed: () => _navigateToDetails(context),
                context: context,
              )
            ];
          }
          return [viewDetailsButtonSecondary];
        default:
        // Para todos los demás estados (awaiting_payment, awaiting_delivery, ongoing)
        // el dueño solo necesita ver los detalles.
          return [viewDetailsButton];
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
    final Color enabledColor =
        color ?? (isSecondary ? const Color(0xFF3A3A3C) : const Color(0xFF48484A));
    final Color disabledColor = const Color(0xFF3A3A3C);

    return SizedBox(
      width: double.infinity,
      height: 28,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? enabledColor : disabledColor,
          foregroundColor: isEnabled ? Colors.white : Colors.grey.shade600,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          textStyle:
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(text, textAlign: TextAlign.center, maxLines: 1),
      ),
    );
  }
}