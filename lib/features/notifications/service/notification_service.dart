// lib/features/notifications/services/notification_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendNotification({
    required String userId, // El ID del usuario que recibirá la notificación
    required NotificationModel notification,
  }) async {
    try {
      // .add() generará un ID único para la notificación automáticamente.
      await _notificationsRef(userId).add(notification);
    } catch (e) {
      print("❌ Error al enviar la notificación: $e");
      // Opcional: puedes re-lanzar el error si quieres manejarlo más arriba.
      // throw e;
    }
  }

  CollectionReference<NotificationModel> _notificationsRef(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .withConverter<NotificationModel>(
      fromFirestore: (snapshot, _) => NotificationModel.fromMap(snapshot.data()!, snapshot.id),
      toFirestore: (model, _) => model.toMap(),
    );
  }

  /// Obtiene un stream de las notificaciones de un usuario, paginadas.
  Stream<List<NotificationModel>> getNotificationsStream(String userId, {int limit = 20}) {
    return _notificationsRef(userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Obtiene un stream con el conteo de notificaciones no leídas.
  Stream<int> getUnreadNotificationsCount(String userId) {
    return _notificationsRef(userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Marca una notificación como leída.
  Future<void> markAsRead(String userId, String notificationId) async {
    try {
      await _notificationsRef(userId).doc(notificationId).update({'isRead': true});
    } catch (e) {
      print("❌ Error al marcar notificación como leída: $e");
    }
  }

  /// Marca todas las notificaciones como leídas.
  Future<void> markAllAsRead(String userId) async {
    try {
      final unreadSnapshot = await _notificationsRef(userId).where('isRead', isEqualTo: false).get();

      final batch = _db.batch();
      for (final doc in unreadSnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      print("❌ Error al marcar todas las notificaciones como leídas: $e");
    }
  }

// NOTA: La creación de notificaciones generalmente se hace desde Cloud Functions
// para mayor seguridad y fiabilidad, no desde el cliente.
}