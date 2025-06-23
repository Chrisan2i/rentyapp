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

class RentalService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final NotificationService _notificationService;

  RentalService({required NotificationService notificationService})
      : _notificationService = notificationService;

  Future<void> createRentalRequest({
    required RentalRequestModel request,
    required String renterName,    // Nombre del que solicita
    required String productTitle,  // Título del producto para el cuerpo de la notificación
  }) async {
    try {
      // 1. Crea el documento de la solicitud de alquiler
      // .add() crea el documento y devuelve una referencia a él.
      final docRef = await _db.collection('rentalRequests').add(request.toMap());
      final newRequestId = docRef.id;

      // (Opcional pero recomendado) Actualiza el documento recién creado para que contenga su propio ID.
      await docRef.update({'requestId': newRequestId});


      // 2. <<<--- LÓGICA PARA CREAR Y ENVIAR LA NOTIFICACIÓN ---<<<
      // Prepara el modelo de la notificación.
      final notificationToSend = NotificationModel(
        notificationId: '', // Firestore generará el ID automáticamente
        type: NotificationType.new_rental_request,
        title: 'You have a new rental request!',
        body: '$renterName wants to rent your product: "$productTitle".',
        createdAt: DateTime.now(),
        isRead: false,
        metadata: {
          'type': 'rental_request', // Para saber qué pantalla abrir al tocar
          'rentalRequestId': newRequestId, // ID para navegar a la solicitud específica
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
      rethrow; // Propaga el error para que la UI lo maneje.
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
      // Usamos una transacción para asegurar que todas las operaciones se completen o ninguna.
      await _db.runTransaction((transaction) async {
        // --- PASO 1: OBTENER REFERENCIAS Y DATOS ---
        final requestRef = _db.collection('rentalRequests').doc(request.requestId);
        final newRentalRef = _db.collection('rentals').doc();

        // Obtenemos los documentos completos para enriquecer el RentalModel
        final ownerDoc = await transaction.get(_db.collection('users').doc(request.ownerId));
        final renterDoc = await transaction.get(_db.collection('users').doc(request.renterId));
        final productDoc = await transaction.get(_db.collection('products').doc(request.productId));

        if (!ownerDoc.exists || !renterDoc.exists || !productDoc.exists) {
          throw Exception("No se encontró el dueño, arrendatario o producto.");
        }

        // --- PASO 2: CONSTRUIR LOS DATOS DENORMALIZADOS ---
        // Usamos nuestros modelos para parsear los datos de forma segura.
        final owner = UserModel.fromMap(ownerDoc.data()!, ownerDoc.id);
        final renter = UserModel.fromMap(renterDoc.data()!, renterDoc.id);
        final product = ProductModel.fromMap(productDoc.data()!, productDoc.id);

        final ownerInfo = {'userId': owner.userId, 'fullName': owner.fullName};
        final renterInfo = {'userId': renter.userId, 'fullName': renter.fullName};
        final productInfo = {'productId': product.productId, 'title': product.title, 'imageUrl': product.images.first};

        // --- PASO 3: CREAR EL NUEVO RENTALMODEL ---
        final newRental = RentalModel(
          rentalId: newRentalRef.id,
          status: RentalStatus.awaiting_payment, // El estado inicial correcto
          productInfo: productInfo,
          ownerInfo: ownerInfo,
          renterInfo: renterInfo,
          startDate: request.startDate, // Ya es DateTime
          endDate: request.endDate, // Ya es DateTime
          financials: request.financials,
          reviewedByRenter: false,
          reviewedByOwner: false,
          createdAt: DateTime.now(),
          involvedUsers: [owner.userId, renter.userId], // Clave para búsquedas eficientes
        );

        // --- PASO 4: EJECUTAR OPERACIONES DE ESCRITURA ---
        // 4a. Actualiza la solicitud a 'accepted'
        transaction.update(requestRef, {'status': 'accepted', 'respondedAt': FieldValue.serverTimestamp()});

        // 4b. Guarda el nuevo RentalModel en la colección 'rentals'
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
      // Esta consulta es muy eficiente gracias al campo 'involvedUsers'
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
      return []; // Devuelve una lista vacía para no romper la UI.
    }
  }
  Future<void> confirmAndPayRental(String rentalId) async {
    // 1. Muestra en consola que el proceso ha comenzado (útil para depuración).
    debugPrint('Procesando pago y confirmación para el alquiler: $rentalId...');

    try {
      // 2. Obtiene la referencia directa al documento del alquiler en Firestore.
      final rentalDocRef = _db.collection('rentals').doc(rentalId);

      // 3. Aquí es donde se realiza la lógica de pago real en un futuro (ej. con Stripe).
      // Por ahora, asumimos que el pago es exitoso y procedemos a actualizar la base de datos.

      // 4. <<<--- ESTA ES LA ACTUALIZACIÓN CLAVE ---<<<
      // Se actualiza el campo 'status' del documento al nuevo estado.
      // Usamos .name para guardar el valor del enum como un String ('awaiting_delivery').
      await rentalDocRef.update({
        'status': RentalStatus.awaiting_delivery.name,
      });

      debugPrint('Éxito: El estado del alquiler $rentalId ha sido actualizado a awaiting_delivery.');

    } on FirebaseException catch (e) {
      // 5. Captura errores específicos de Firebase (ej. permisos, no encontrado).
      debugPrint("Error de Firestore al actualizar el alquiler: ${e.message}");
      // Re-lanza el error para que el controlador lo capture y muestre un mensaje al usuario.
      throw Exception("No se pudo confirmar el alquiler. Por favor, intenta de nuevo.");
    } catch (e) {
      // 6. Captura cualquier otro error inesperado.
      debugPrint("Error inesperado en confirmAndPayRental: ${e.toString()}");
      throw Exception("Ocurrió un error inesperado. Por favor, intenta de nuevo.");
    }
  }
}