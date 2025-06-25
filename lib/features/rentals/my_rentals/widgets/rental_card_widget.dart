// lib/features/rentals/widgets/rental_card_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/rentals/rentals_details/rental_details_view.dart';

// --- ✨ MEJORA: Extensión de estado con textos en español ---
extension RentalStatusExtension on RentalStatus {
  String get displayName {
    switch (this) {
      case RentalStatus.awaiting_payment: return 'Pendiente de Pago';
      case RentalStatus.awaiting_delivery: return 'Pendiente de Entrega';
      case RentalStatus.ongoing: return 'En Curso';
      case RentalStatus.completed: return 'Completado';
      case RentalStatus.cancelled: return 'Cancelado';
      case RentalStatus.disputed: return 'En Disputa';
    }
  }

  Color get displayColor {
    switch (this) {
      case RentalStatus.awaiting_payment: return Colors.orange.shade700;
      case RentalStatus.awaiting_delivery: return Colors.blue.shade600;
      case RentalStatus.ongoing: return const Color(0xFF0A84FF);
      case RentalStatus.completed: return const Color(0xFF34C759);
      case RentalStatus.cancelled: return Colors.grey.shade600;
      case RentalStatus.disputed: return const Color(0xFFFF3B30);
    }
  }
}

class RentalCardWidget extends StatelessWidget {
  final RentalModel rental;
  final String currentTab;
  final Function(RentalModel rental) onPayNowPressed;

  const RentalCardWidget({
    super.key,
    required this.rental,
    required this.currentTab,
    required this.onPayNowPressed,
  });

  void _navigateToDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RentalDetailsScreen(
          rental: rental,
          viewerRole: currentTab,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetails(context),
      child: Container(
        padding: const EdgeInsets.all(12.0),
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
    final bool hasValidUrl = imageUrl != null && imageUrl.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: hasValidUrl
          ? Image.network(
        imageUrl,
        width: 72, height: 72, fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: 72, height: 72, color: Colors.grey.shade800,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey.shade600)),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
      )
          : _buildFallbackImage(),
    );
  }

  // ✨ MEJORA: Fallback con ícono es más limpio que con texto.
  Widget _buildFallbackImage() {
    return Container(
      width: 72, height: 72,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: const Center(
        child: Icon(Icons.inventory_2_outlined, color: Colors.white54, size: 30),
      ),
    );
  }

  Widget _buildInfoColumn() {
    final isOngoing = rental.status == RentalStatus.ongoing || rental.status == RentalStatus.awaiting_delivery;
    // ✨ MEJORA: Textos de fecha y relación en español.
    final datePrefix = isOngoing ? 'Vence: ' : 'Finalizó: ';
    final formattedDate = DateFormat('d MMM', 'es_ES').format(rental.endDate);
    final ownerName = rental.ownerInfo['fullName'] as String? ?? 'Propietario';
    final renterName = rental.renterInfo['fullName'] as String? ?? 'Arrendatario';
    final relationshipText = currentTab == 'renter' ? 'De $ownerName' : 'Por $renterName';
    final itemTitle = rental.productInfo['title'] as String? ?? 'Producto sin título';
    final total = rental.financials['total'] ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(itemTitle, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.person_outline, color: Colors.grey.shade500, size: 14),
            const SizedBox(width: 4),
            Expanded(child: Text(relationshipText, style: TextStyle(color: Colors.grey.shade400, fontSize: 12), overflow: TextOverflow.ellipsis)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: Colors.grey.shade500, size: 14),
            const SizedBox(width: 4),
            Text('$datePrefix$formattedDate', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        Text('\$${total.toStringAsFixed(2)} total', style: const TextStyle(color: Color(0xFF0A84FF), fontSize: 15, fontWeight: FontWeight.bold)),
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
      child: Text(rental.status.displayName, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    final viewDetailsButton = _buildActionButton(text: 'Ver Detalles', onPressed: () => _navigateToDetails(context), context: context);
    final viewDetailsButtonSecondary = _buildActionButton(text: 'Ver Detalles', onPressed: () => _navigateToDetails(context), context: context, isSecondary: true);

    if (currentTab == 'renter') {
      switch (rental.status) {
        case RentalStatus.awaiting_payment:
          return [_buildActionButton(text: 'Pagar Ahora', onPressed: () => onPayNowPressed(rental), context: context, color: Colors.green.shade600)];
        case RentalStatus.completed:
          if (!rental.reviewedByRenter) {
            return [_buildActionButton(text: 'Dejar Reseña', onPressed: () => _navigateToDetails(context), context: context, color: const Color(0xFF34C759))];
          }
          return [viewDetailsButtonSecondary];
        case RentalStatus.ongoing:
        case RentalStatus.awaiting_delivery:
          return [viewDetailsButton];
        default:
          return [viewDetailsButtonSecondary];
      }
    } else { // owner
      switch (rental.status) {
        case RentalStatus.completed:
        case RentalStatus.disputed:
          if (!rental.reviewedByOwner) {
            return [_buildActionButton(text: 'Ver Detalles', onPressed: () => _navigateToDetails(context), context: context)];
          }
          return [viewDetailsButtonSecondary];
        default:
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
    // ... (El estilo del botón no necesita cambios, está bien)
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
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(text, textAlign: TextAlign.center, maxLines: 1),
      ),
    );
  }
}