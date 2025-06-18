// lib/features/rentals/models/rental_model.dart
import 'package:flutter/material.dart';

// El enum ahora incluye 'late' y 'cancelled' para ser más completo.
enum RentalStatus { ongoing, late, completed, cancelled }

// Esta 'extension' es una forma limpia de asociar propiedades (como nombre y color)
// a cada estado del enum, sin ensuciar la lógica del modelo.
extension RentalStatusDetails on RentalStatus {
  String get displayName {
    switch (this) {
      case RentalStatus.ongoing: return 'ongoing';
      case RentalStatus.late: return 'late';
      case RentalStatus.completed: return 'completed';
      case RentalStatus.cancelled: return 'cancelled';
    }
  }

  Color get displayColor {
    switch (this) {
      case RentalStatus.ongoing: return const Color(0xFF007BFF); // Azul
      case RentalStatus.late: return const Color(0xFFFFA500);    // Naranja
      case RentalStatus.completed: return const Color(0xFF28A745);  // Verde
      case RentalStatus.cancelled: return Colors.red;
    }
  }
}

class RentalModel {
  final String rentalId;
  final String itemId;
  final String itemName;         // <-- NUEVO
  final String itemImageUrl;     // <-- NUEVO
  final String renterId;
  final String renterName;       // <-- NUEVO
  final String ownerId;
  final String ownerName;        // <-- NUEVO
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final RentalStatus status;
  final bool reviewedByRenter;
  final bool reviewedByOwner;
  final bool issueReported;      // <-- NUEVO (Para el botón Report Issue)
  final DateTime createdAt;

  RentalModel({
    required this.rentalId,
    required this.itemId,
    required this.itemName,
    required this.itemImageUrl,
    required this.renterId,
    required this.renterName,
    required this.ownerId,
    required this.ownerName,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.reviewedByRenter,
    required this.reviewedByOwner,
    this.issueReported = false, // Valor por defecto
    required this.createdAt,
  });

  // Convertir el modelo a un mapa para guardarlo en Firestore
  Map<String, dynamic> toJson() => {
    'rentalId': rentalId,
    'itemId': itemId,
    'itemName': itemName,
    'itemImageUrl': itemImageUrl,
    'renterId': renterId,
    'renterName': renterName,
    'ownerId': ownerId,
    'ownerName': ownerName,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'totalPrice': totalPrice,
    'status': status.name, // .name convierte el enum a String (ej: 'ongoing')
    'reviewedByRenter': reviewedByRenter,
    'reviewedByOwner': reviewedByOwner,
    'issueReported': issueReported,
    'createdAt': createdAt.toIso8601String(),
  };

  // Crear un modelo a partir de un mapa de Firestore
  factory RentalModel.fromJson(Map<String, dynamic> json) {
    return RentalModel(
      rentalId: json['rentalId'] ?? '',
      itemId: json['itemId'] ?? '',
      itemName: json['itemName'] ?? 'No Name', // Añade valores por defecto
      itemImageUrl: json['itemImageUrl'] ?? 'https://placehold.co/80x80', // URL por defecto
      renterId: json['renterId'] ?? '',
      renterName: json['renterName'] ?? 'N/A',
      ownerId: json['ownerId'] ?? '',
      ownerName: json['ownerName'] ?? 'N/A',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      status: RentalStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => RentalStatus.ongoing, // Valor seguro si el status es nulo o inválido
      ),
      reviewedByRenter: json['reviewedByRenter'] ?? false,
      reviewedByOwner: json['reviewedByOwner'] ?? false,
      issueReported: json['issueReported'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Método copyWith para crear una copia del objeto con algunos campos modificados
  RentalModel copyWith({
    String? rentalId,
    String? itemId,
    String? itemName,
    String? itemImageUrl,
    String? renterId,
    String? renterName,
    String? ownerId,
    String? ownerName,
    DateTime? startDate,
    DateTime? endDate,
    double? totalPrice,
    RentalStatus? status,
    bool? reviewedByRenter,
    bool? reviewedByOwner,
    bool? issueReported,
    DateTime? createdAt,
  }) {
    return RentalModel(
      rentalId: rentalId ?? this.rentalId,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      itemImageUrl: itemImageUrl ?? this.itemImageUrl,
      renterId: renterId ?? this.renterId,
      renterName: renterName ?? this.renterName,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      reviewedByRenter: reviewedByRenter ?? this.reviewedByRenter,
      reviewedByOwner: reviewedByOwner ?? this.reviewedByOwner,
      issueReported: issueReported ?? this.issueReported,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}