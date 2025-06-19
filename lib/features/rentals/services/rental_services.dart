// lib/features/rentals/services/rental_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Asegúrate que las rutas de importación son las correctas para tu proyecto
import 'package:rentyapp/features/auth/models/user_model.dart';
import 'package:rentyapp/features/product/models/product_model.dart';
import 'package:rentyapp/features/send_rental_request/models/rental_request_model.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';

class RentalService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // =======================================================================
  // GESTIÓN DE SOLICITUDES DE ALQUILER (REQUESTS)
  // =======================================================================

  /// Crea una nueva solicitud de alquiler en Firestore.
  Future<void> createRentalRequest(RentalRequestModel request) async {
    try {
      await _db.collection('rentalRequests').add(request.toMap());
    } catch (e) {
      debugPrint("❌ Error al crear la solicitud de alquiler: $e");
      rethrow; // Propaga el error para que el controlador lo maneje.
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
          status: RentalStatus.awaiting_delivery, // El estado inicial correcto
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
}