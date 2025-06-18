import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// Asegúrate que las rutas de importación sean las correctas para tu proyecto
import 'package:rentyapp/features/send_rental_request/models/rental_request_model.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';

class RentalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Crea una nueva solicitud de alquiler en Firestore.
  Future<bool> createRentalRequest(RentalRequestModel request) async {
    try {
      await _firestore.collection('rental_requests').add(request.toMap());
      return true;
    } catch (e) {
      debugPrint("Error creating rental request: $e");
      return false;
    }
  }

  /// Obtiene un stream de solicitudes de alquiler para un dueño específico.
  Stream<List<RentalRequestModel>> getRentalRequestsForOwner(String ownerId) {
    return _firestore
        .collection('rental_requests')
        .where('ownerId', isEqualTo: ownerId)
    // Opcional: Filtra solo las que están pendientes si no quieres mostrar las ya aceptadas/rechazadas
    // .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => RentalRequestModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Future<bool> acceptRentalRequest(RentalRequestModel request) async {
    try {
      // --- PASO 1: OBTENER DATOS ADICIONALES DE FIRESTORE ---
      // Usamos los IDs del 'request' para buscar los documentos completos.
      final results = await Future.wait([
        _firestore.collection('users').doc(request.ownerId).get(),
        _firestore.collection('users').doc(request.renterId).get(),
        _firestore.collection('products').doc(request.productId).get(), // ¡Revisa que tu colección se llame 'products'!
      ]);

      final ownerDoc = results[0];
      final renterDoc = results[1];
      final productDoc = results[2];

      // Verificamos que todos los documentos existan antes de continuar.
      if (!ownerDoc.exists || !renterDoc.exists || !productDoc.exists) {
        debugPrint("Error: No se encontró el documento del dueño, arrendatario o producto.");
        return false;
      }

      // Extraemos los datos necesarios. ¡Revisa que los nombres de los campos ('name', 'imageUrl') sean correctos!
      final String ownerName = (ownerDoc.data() as Map<String, dynamic>)['name'] ?? 'Dueño';
      final String renterName = (renterDoc.data() as Map<String, dynamic>)['name'] ?? 'Arrendatario';
      final productData = productDoc.data() as Map<String, dynamic>;
      final String productName = productData['name'] ?? 'Artículo';
      final String productImageUrl = productData['imageUrl'] ?? 'https://placehold.co/80x80';

      // --- PASO 2: EJECUTAR LA TRANSACCIÓN EN FIRESTORE ---
      await _firestore.runTransaction((transaction) async {
        final requestRef = _firestore.collection('rental_requests').doc(request.requestId);
        final newRentalRef = _firestore.collection('rentals').doc();

        // 2a. Actualiza la solicitud a 'accepted'
        transaction.update(requestRef, {'status': 'accepted', 'respondedAt': Timestamp.now()});

        // 2b. Crea el nuevo objeto RentalModel con los datos ya enriquecidos
        final newRental = RentalModel(
          rentalId: newRentalRef.id,
          itemId: request.productId,
          renterId: request.renterId,
          ownerId: request.ownerId,
          startDate: request.startDate.toDate(),
          endDate: request.endDate.toDate(),
          totalPrice: request.total,

          // --- AQUÍ USAMOS LOS DATOS QUE BUSCAMOS ---
          itemName: productName,
          itemImageUrl: productImageUrl,
          renterName: renterName,
          ownerName: ownerName,
          // ----------------------------------------

          status: RentalStatus.ongoing,
          reviewedByRenter: false,
          reviewedByOwner: false,
          issueReported: false,
          createdAt: DateTime.now(),
        );

        // 2c. Guarda el nuevo RentalModel completo en la colección 'rentals'
        transaction.set(newRentalRef, newRental.toJson());
      });

      return true; // La operación fue un éxito

    } catch (e) {
      debugPrint("Error al aceptar la solicitud de alquiler: $e");
      return false;
    }
  }

  /// Rechaza una solicitud de alquiler (este método se mantiene igual)
  Future<bool> declineRentalRequest(String requestId) async {
    try {
      await _firestore.collection('rental_requests').doc(requestId).update({
        'status': 'declined',
        'respondedAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      debugPrint("Error al rechazar la solicitud de alquiler: $e");
      return false;
    }
  }
  Stream<int> getPendingRentalRequestsCount(String ownerId) {
    return _firestore
        .collection('rental_requests')
        .where('ownerId', isEqualTo: ownerId)
        .where('status', isEqualTo: 'pending') // Filtramos solo las pendientes
        .snapshots() // Nos suscribimos a los cambios en tiempo real
        .map((snapshot) => snapshot.docs.length); // Mapeamos el resultado al número de documentos
  }
}