// lib/features/notifications/models/notification_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  new_rental_request,
  request_accepted,
  request_rejected,
  rental_completed,
  new_review,
  new_message,
  payout_processed,
  account_verified,
  system_alert,
}

class NotificationModel {
  final String notificationId;
  final NotificationType type;
  final String title;
  final String body;
  final bool isRead;

  // Metadatos para la navegación
  // ej: {'rentalId': '...', 'chatId': '...'}
  final Map<String, String> metadata;

  final DateTime createdAt;

  NotificationModel({
    required this.notificationId,
    required this.type,
    required this.title,
    required this.body,
    this.isRead = false,
    this.metadata = const {},
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      notificationId: id,
      type: NotificationType.values.firstWhere(
            (e) => e.name == map['type'],
        orElse: () => NotificationType.system_alert,
      ),
      title: map['title'] ?? 'Notificación',
      body: map['body'] ?? '',
      isRead: map['isRead'] ?? false,
      metadata: Map<String, String>.from(map['metadata'] ?? {}),
      createdAt: (map['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'title': title,
      'body': body,
      'isRead': isRead,
      'metadata': metadata,
      'createdAt': createdAt,
    };
  }
}