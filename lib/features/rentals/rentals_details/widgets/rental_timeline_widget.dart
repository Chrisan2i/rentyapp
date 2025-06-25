// lib/features/rentals/views/details_widgets/rental_timeline_widget.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';

class RentalTimelineWidget extends StatelessWidget {
  final RentalModel rental;
  const RentalTimelineWidget({super.key, required this.rental});

  @override
  Widget build(BuildContext context) {
    // ✨ MEJORA: Uso de Theme para consistencia
    final theme = Theme.of(context);
    final dateFormat = DateFormat('d MMM, yyyy \'a las\' hh:mm a', 'es_ES');

    // ✨ MEJORA: Definición de estados para mayor claridad
    final isPaymentConfirmed = rental.status != RentalStatus.awaiting_payment;
    final isItemDelivered = rental.status == RentalStatus.ongoing || rental.status == RentalStatus.completed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // ✨ MEJORA: Texto en español
            'Línea de Tiempo del Alquiler',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // ✨ MEJORA: Todos los textos traducidos a español
          _TimelineStep(
            title: 'Solicitud Recibida',
            subtitle: dateFormat.format(rental.createdAt),
            isCompleted: true,
          ),
          _TimelineStep(
            title: 'Solicitud Aprobada',
            subtitle: dateFormat.format(rental.createdAt.add(const Duration(minutes: 5))), // Dato de ejemplo
            isCompleted: true,
          ),
          _TimelineStep(
            title: 'Pago Confirmado',
            subtitle: isPaymentConfirmed ? 'Pago realizado' : 'Pendiente...',
            isCompleted: isPaymentConfirmed,
          ),
          _TimelineStep(
            title: 'Producto Entregado',
            subtitle: isItemDelivered ? 'Entrega confirmada' : 'Pendiente...',
            isCompleted: isItemDelivered,
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
    // ✨ MEJORA: Color primario para mayor consistencia visual
    final activeColor = Colors.blueAccent;
    final inactiveColor = Colors.grey.shade600;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? activeColor : inactiveColor,
              size: 20,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: isCompleted ? activeColor : inactiveColor,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isCompleted ? Colors.white : Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    subtitle!,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}