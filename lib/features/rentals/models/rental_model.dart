// lib/features/rentals/models/rental_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// Enum para un manejo de estado claro, robusto y sin errores de tipeo.
enum RentalStatus {
  awaiting_payment,
  awaiting_delivery, // Aceptado y pagado, esperando que el dueño entregue el producto.
  ongoing,           // El arrendatario tiene el producto.
  completed,         // El producto fue devuelto y el ciclo finalizó correctamente.
  cancelled,         // El alquiler fue cancelado antes o durante el proceso.
  disputed           // Se ha reportado un problema (ej. daño, no devolución).
}

class RentalModel {
  final String rentalId;
  final RentalStatus status;

  // --- Información Denormalizada (Congelada al momento del alquiler) ---
  // Guardamos esta información aquí para evitar consultas extra a otras colecciones
  // y para tener un registro histórico de cómo eran los datos en ese momento.

  // Información del producto alquilado
  final Map<String, dynamic> productInfo; // ej: {'productId': '...', 'title': '...', 'imageUrl': '...'}

  // Información del dueño del producto
  final Map<String, dynamic> ownerInfo; // ej: {'userId': '...', 'fullName': '...'}

  // Información del arrendatario
  final Map<String, dynamic> renterInfo; // ej: {'userId': '...', 'fullName': '...'}

  // --- Fechas y Finanzas ---
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, double> financials; // ej: {'subtotal': 50.0, 'serviceFee': 7.5, 'total': 57.5}

  // --- Seguimiento del Proceso y Estado ---
  final DateTime? deliveryConfirmedAt; // Timestamp de cuando el arrendatario confirma la recepción.
  final DateTime? returnConfirmedAt;   // Timestamp de cuando el dueño confirma la devolución.
  final bool reviewedByRenter;
  final bool reviewedByOwner;

  // --- Metadatos ---
  final DateTime createdAt; // Fecha de creación del documento de alquiler.

  // <<<--- CAMPO CLAVE PARA CONSULTAS EFICIENTES ---<<<
  // Contiene los UIDs tanto del dueño como del arrendatario.
  // Permite hacer una sola consulta 'array-contains' para obtener todos los alquileres de un usuario.
  final List<String> involvedUsers;

  RentalModel({
    required this.rentalId,
    required this.status,
    required this.productInfo,
    required this.ownerInfo,
    required this.renterInfo,
    required this.startDate,
    required this.endDate,
    required this.financials,
    this.deliveryConfirmedAt,
    this.returnConfirmedAt,
    this.reviewedByRenter = false,
    this.reviewedByOwner = false,
    required this.createdAt,
    required this.involvedUsers,
  });

  /// Factory constructor para crear una instancia de RentalModel desde un mapa de Firestore.
  factory RentalModel.fromMap(Map<String, dynamic> map, String id) {
    return RentalModel(
      rentalId: id,
      status: RentalStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => RentalStatus.cancelled, // Valor por defecto seguro
      ),
      productInfo: Map<String, dynamic>.from(map['productInfo'] ?? {}),
      ownerInfo: Map<String, dynamic>.from(map['ownerInfo'] ?? {}),
      renterInfo: Map<String, dynamic>.from(map['renterInfo'] ?? {}),
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      financials: (map['financials'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(key, (value as num).toDouble())),
      deliveryConfirmedAt: (map['deliveryConfirmedAt'] as Timestamp?)?.toDate(),
      returnConfirmedAt: (map['returnConfirmedAt'] as Timestamp?)?.toDate(),
      reviewedByRenter: map['reviewedByRenter'] ?? false,
      reviewedByOwner: map['reviewedByOwner'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      involvedUsers: List<String>.from(map['involvedUsers'] ?? []),
    );
  }

  /// Convierte la instancia de RentalModel a un mapa para guardarlo en Firestore.
  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'productInfo': productInfo,
      'ownerInfo': ownerInfo,
      'renterInfo': renterInfo,
      'startDate': startDate,
      'endDate': endDate,
      'financials': financials,
      'deliveryConfirmedAt': deliveryConfirmedAt,
      'returnConfirmedAt': returnConfirmedAt,
      'reviewedByRenter': reviewedByRenter,
      'reviewedByOwner': reviewedByOwner,
      'createdAt': createdAt,
      'involvedUsers': involvedUsers,
    };
  }
}