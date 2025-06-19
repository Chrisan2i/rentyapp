// lib/features/rentals/widgets/rental_card_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';

// --- Extensión para el Enum RentalStatus ---
// Añade propiedades personalizadas para la UI sin modificar el modelo.
// Esto centraliza la lógica de visualización del estado.
extension RentalStatusExtension on RentalStatus {
  String get displayName {
    switch (this) {
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
      case RentalStatus.awaiting_delivery:
        return Colors.orange.shade700; // Naranja para estados pendientes
      case RentalStatus.ongoing:
        return const Color(0xFF0A84FF); // Azul para en curso
      case RentalStatus.completed:
        return const Color(0xFF34C759); // Verde para completado
      case RentalStatus.cancelled:
        return Colors.grey.shade600;    // Gris para cancelado
      case RentalStatus.disputed:
        return const Color(0xFFFF3B30); // Rojo para disputas
    }
  }
}


class RentalCardWidget extends StatelessWidget {
  final RentalModel rental;
  final String currentTab; // 'renter' o 'owner'

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
        color: const Color(0xFF2C2C2E), // Color de la tarjeta
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
    // CORREGIDO: Acceso a la URL de la imagen y al título desde el mapa 'productInfo'.
    final imageUrl = rental.productInfo['imageUrl'] as String?;
    final title = rental.productInfo['title'] as String? ?? 'N/A';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.network(
        imageUrl ?? '', // Se pasa un string vacío para forzar el errorBuilder si la URL es nula.
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
                title.length > 4 ? title.substring(0, 4) : title,
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
    // CORREGIDO: Se ajustó el estado "en curso" según el enum del modelo.
    final isOngoing = rental.status == RentalStatus.ongoing || rental.status == RentalStatus.awaiting_delivery;
    final datePrefix = isOngoing ? 'Due: ' : 'Completed: ';
    final formattedDate = DateFormat('MMM dd').format(rental.endDate);

    // CORREGIDO: Acceso a los nombres desde los mapas 'ownerInfo' y 'renterInfo'.
    final ownerName = rental.ownerInfo['fullName'] as String? ?? 'Owner';
    final renterName = rental.renterInfo['fullName'] as String? ?? 'Renter';
    final relationshipText = currentTab == 'renter'
        ? 'You rented from $ownerName'
        : 'Rented by $renterName';

    // CORREGIDO: Acceso al título y al precio total desde 'productInfo' y 'financials'.
    final itemTitle = rental.productInfo['title'] as String? ?? 'Untitled Product';
    final total = rental.financials['total'] ?? 0.0;

    return SizedBox(
      height: 72,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            itemTitle,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Icon(Icons.person_outline, color: Colors.grey.shade500, size: 14),
              const SizedBox(width: 4),
              Expanded( // Expanded para evitar overflow si los nombres son largos
                child: Text(
                  relationshipText,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
            '\$${total.toInt()} total',
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
    // CORREGIDO: Uso de la extensión para obtener color y texto del estado.
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
    // CORREGIDO: El estado 'late' no existe, se ajustó a los estados del modelo.
    final bool isOngoing = rental.status == RentalStatus.ongoing || rental.status == RentalStatus.awaiting_delivery;

    // La lógica de los botones ya usaba campos correctos del modelo (reviewedByRenter/Owner).
    if (currentTab == 'renter') {
      if (isOngoing) {
        return [
          _buildActionButton(text: 'View Details', onPressed: () {}, context: context),
        ];
      } else { // Pasado (Completed, Cancelled, Disputed)
        if (rental.status == RentalStatus.completed && !rental.reviewedByRenter) {
          return [_buildActionButton(text: 'Leave Review', onPressed: () {}, context: context, color: const Color(0xFF34C759))];
        } else {
          return [_buildActionButton(text: 'View Details', onPressed: () {}, context: context, isSecondary: true)];
        }
      }
    } else { // Owner
      if (isOngoing) {
        return [
          _buildActionButton(text: 'View Details', onPressed: () {}, context: context),
        ];
      } else { // Pasado
        // Los dueños pueden reportar problemas incluso después de completado.
        if(rental.status == RentalStatus.completed || rental.status == RentalStatus.disputed) {
          return [
            _buildActionButton(text: 'Report Issue', onPressed: () {}, context: context, color: const Color(0xFFFF3B30)),
          ];
        } else {
          return [_buildActionButton(text: 'View Details', onPressed: () {}, context: context, isSecondary: true)];
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