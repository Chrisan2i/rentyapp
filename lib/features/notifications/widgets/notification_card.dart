// lib/features/notifications/widgets/notification_card.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/features/notifications/model/notification_model.dart';
import 'package:timeago/timeago.dart' as timeago;

// Helper para mapear tipos de notificación a un icono y color
class NotificationVisuals {
  final IconData icon;
  final Color color;

  NotificationVisuals(this.icon, this.color);

  static NotificationVisuals fromType(NotificationType type) {
    switch (type) {
      case NotificationType.new_rental_request:
      case NotificationType.new_message:
        return NotificationVisuals(Icons.mail_outline, Colors.blue.shade400);
      case NotificationType.request_accepted:
      case NotificationType.rental_completed:
      case NotificationType.payout_processed:
      case NotificationType.account_verified:
        return NotificationVisuals(Icons.check_circle_outline, Colors.green.shade400);
      case NotificationType.request_rejected:
        return NotificationVisuals(Icons.cancel_outlined, Colors.red.shade400);
      case NotificationType.new_review:
        return NotificationVisuals(Icons.star_outline, Colors.amber.shade400);
      default: // system_alert y otros
        return NotificationVisuals(Icons.notifications_active_outlined, Colors.grey.shade400);
    }
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final visuals = NotificationVisuals.fromType(notification.type);
    final timeAgo = timeago.format(notification.createdAt);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: visuals.color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(visuals.icon, color: visuals.color, size: 22),
            ),
            const SizedBox(width: 12),
            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Punto de "No Leído"
            if (!notification.isRead)
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}