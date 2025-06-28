// lib/features/rentals/services/rental_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Asegúrate que las rutas de importación son las correctas para tu proyecto
import 'package:rentyapp/features/auth/models/user_model.dart';
import 'package:rentyapp/features/product/models/product_model.dart';
import 'package:rentyapp/features/send_rental_request/models/rental_request_model.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/notifications/model/notification_model.dart';
import 'package:rentyapp/features/notifications/service/notification_service.dart';
import 'package:rentyapp/features/rentals/models/contract_model.dart';

class RentalService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final NotificationService _notificationService;

  RentalService({required NotificationService notificationService})
      : _notificationService = notificationService;

  /// Crea el documento de contrato bajo rentals/{rentalId}/contract/{contractId}
  static Future<void> createContract(String rentalId, ContractModel contract) {
    final rentalRef = FirebaseFirestore.instance
        .collection('rentals')
        .doc(rentalId);
    final contractRef = rentalRef
        .collection('contract')
        .doc(contract.contractId);
    return contractRef.set(contract.toMap());
  }

  Future<void> createRentalRequest({
    required RentalRequestModel request,
    required String renterName,    // Nombre del que solicita
    required String productTitle,  // Título del producto para el cuerpo de la notificación
  }) async {
    try {
      // 1. Crea el documento de la solicitud de alquiler
      final docRef = await _db.collection('rentalRequests').add(request.toMap());
      final newRequestId = docRef.id;

      await docRef.update({'requestId': newRequestId});

      // 2. <<<--- LÓGICA PARA CREAR Y ENVIAR LA NOTIFICACIÓN (CON TEXTOS TRADUCIDOS) ---<<<
      final notificationToSend = NotificationModel(
        notificationId: '',
        type: NotificationType.new_rental_request,
        // TRADUCCIÓN: Título de la notificación
        title: '¡Tienes una nueva solicitud de renta!',
        // TRADUCCIÓN: Cuerpo de la notificación
        body: '$renterName quiere rentar tu producto: "$productTitle".',
        createdAt: DateTime.now(),
        isRead: false,
        metadata: {
          'type': 'rental_request',
          'rentalRequestId': newRequestId,
          'productId': request.productId,
        },
      );

      // 3. Usa el servicio de notificaciones para enviarla al dueño del producto.
      await _notificationService.sendNotification(
        userId: request.ownerId,
        notification: notificationToSend,
      );

    } catch (e) {
      debugPrint("❌ Error al crear la solicitud de alquiler y/o la notificación: $e");
      rethrow;
    }
  }

  /// Obtiene un stream de solicitudes de alquiler para un dueño específico.
  Stream<List<RentalRequestModel>> getRentalRequestsForOwner(String ownerId) {
    return _db
        .collection('rentalRequests')
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RentalRequestModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Obtiene un stream con el conteo de solicitudes pendientes para un dueño.
  Stream<int> getPendingRentalRequestsCount(String ownerId) {
    return _db
        .collection('rentalRequests')
        .where('ownerId', isEqualTo: ownerId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Acepta una solicitud de alquiler. Esto actualiza la solicitud y crea un nuevo alquiler.
  Future<void> acceptRentalRequest(RentalRequestModel request) async {
    try {
      await _db.runTransaction((transaction) async {
        final requestRef = _db.collection('rentalRequests').doc(request.requestId);
        final newRentalRef = _db.collection('rentals').doc();

        final ownerDoc = await transaction.get(_db.collection('users').doc(request.ownerId));
        final renterDoc = await transaction.get(_db.collection('users').doc(request.renterId));
        final productDoc = await transaction.get(_db.collection('products').doc(request.productId));

        if (!ownerDoc.exists || !renterDoc.exists || !productDoc.exists) {
          // TRADUCCIÓN: Mensaje de error interno (visible en consola o si se propaga la excepción)
          throw Exception("No se encontró el dueño, arrendatario o producto.");
        }

        final owner = UserModel.fromMap(ownerDoc.data()!, ownerDoc.id);
        final renter = UserModel.fromMap(renterDoc.data()!, renterDoc.id);
        final product = ProductModel.fromMap(productDoc.data()!, productDoc.id);

        final ownerInfo = {'userId': owner.userId, 'fullName': owner.fullName};
        final renterInfo = {'userId': renter.userId, 'fullName': renter.fullName};
        final productInfo = {'productId': product.productId, 'title': product.title, 'imageUrl': product.images.first};

        final newRental = RentalModel(
          rentalId: newRentalRef.id,
          status: RentalStatus.awaiting_payment,
          productInfo: productInfo,
          ownerInfo: ownerInfo,
          renterInfo: renterInfo,
          startDate: request.startDate,
          endDate: request.endDate,
          financials: request.financials,
          reviewedByRenter: false,
          reviewedByOwner: false,
          createdAt: DateTime.now(),
          involvedUsers: [owner.userId, renter.userId],
        );

        transaction.update(requestRef, {'status': 'accepted', 'respondedAt': FieldValue.serverTimestamp()});
        transaction.set(newRentalRef, newRental.toMap());
      });

    } catch (e) {
      debugPrint("❌ Error al aceptar la solicitud de alquiler: $e");
      rethrow;
    }
  }

  /// Rechaza una solicitud de alquiler.
  Future<void> declineRentalRequest(String requestId) async {
    try {
      await _db.collection('rentalRequests').doc(requestId).update({
        'status': 'declined',
        'respondedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("❌ Error al rechazar la solicitud de alquiler: $e");
      rethrow;
    }
  }

  /// Obtiene todos los alquileres (como dueño o arrendatario) de un usuario.
  Future<List<RentalModel>> getRentalsForUser(String userId) async {
    try {
      final snapshot = await _db
          .collection('rentals')
          .where('involvedUsers', arrayContains: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => RentalModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint("❌ Error al obtener alquileres del usuario: $e");
      return [];
    }
  }

  Future<void> confirmAndPayRental(String rentalId) async {
    debugPrint('Procesando pago y confirmación para el alquiler: $rentalId...');

    try {
      final rentalDocRef = _db.collection('rentals').doc(rentalId);

      await rentalDocRef.update({
        'status': RentalStatus.awaiting_delivery.name,
      });

      debugPrint('Éxito: El estado del alquiler $rentalId ha sido actualizado a awaiting_delivery.');

    } on FirebaseException catch (e) {
      debugPrint("Error de Firestore al actualizar el alquiler: ${e.message}");
      // TRADUCCIÓN: Mensaje de error para el usuario
      throw Exception("No se pudo confirmar el alquiler. Por favor, intenta de nuevo.");
    } catch (e) {
      debugPrint("Error inesperado en confirmAndPayRental: ${e.toString()}");
      // TRADUCCIÓN: Mensaje de error para el usuario
      throw Exception("Ocurrió un error inesperado. Por favor, intenta de nuevo.");
    }
  }

  Future<void> confirmDelivery(String rentalId) async {
    try {
      final rentalRef = _db.collection('rentals').doc(rentalId);
      await rentalRef.update({
        'status': RentalStatus.ongoing.name,
        'deliveryConfirmedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Entrega confirmada para el alquiler: $rentalId');
    } catch (e) {
      debugPrint('❌ Error al confirmar la entrega: $e');
      rethrow;
    }
  }

  Future<void> completeRental(String rentalId) async {
    try {
      final rentalRef = _db.collection('rentals').doc(rentalId);
      await rentalRef.update({
        'status': RentalStatus.completed.name,
        'returnConfirmedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Alquiler completado: $rentalId');
    } catch (e) {
      debugPrint('❌ Error al completar el alquiler: $e');
      rethrow;
    }
  }
}