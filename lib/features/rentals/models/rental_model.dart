// lib/features/rentals/models/rental_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'contract_model.dart';

/// Enum para estados de alquiler.
enum RentalStatus {
  awaiting_payment,
  awaiting_delivery,
  ongoing,
  completed,
  cancelled,
  disputed,
}

/// Modelo que representa un alquiler y ahora incluye opcionalmente el contrato digital.
class RentalModel {
  final String rentalId;
  final RentalStatus status;

  // Información denormalizada
  final Map<String, dynamic> productInfo;
  final Map<String, dynamic> ownerInfo;
  final Map<String, dynamic> renterInfo;

  // Fechas y finanzas
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, double> financials;

  // Seguimiento del proceso
  final DateTime? deliveryConfirmedAt;
  final DateTime? returnConfirmedAt;
  final bool reviewedByRenter;
  final bool reviewedByOwner;

  // Metadatos
  final DateTime createdAt;
  final List<String> involvedUsers;

  // Contrato digital asociado (opcional)
  final ContractModel? contract;

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
    this.contract,
  });

  factory RentalModel.fromMap(
      Map<String, dynamic> map,
      String id, {
        ContractModel? contract,
      }) {
    return RentalModel(
      rentalId: id,
      status: RentalStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => RentalStatus.cancelled,
      ),
      productInfo: Map<String, dynamic>.from(map['productInfo'] ?? {}),
      ownerInfo: Map<String, dynamic>.from(map['ownerInfo'] ?? {}),
      renterInfo: Map<String, dynamic>.from(map['renterInfo'] ?? {}),
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      financials: (map['financials'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ?? {},
      deliveryConfirmedAt:
      (map['deliveryConfirmedAt'] as Timestamp?)?.toDate(),
      returnConfirmedAt: (map['returnConfirmedAt'] as Timestamp?)?.toDate(),
      reviewedByRenter: map['reviewedByRenter'] ?? false,
      reviewedByOwner: map['reviewedByOwner'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      involvedUsers: List<String>.from(map['involvedUsers'] ?? []),
      contract: contract,
    );
  }

  Map<String, dynamic> toMap() {
    final m = {
      'status': status.name,
      'productInfo': productInfo,
      'ownerInfo': ownerInfo,
      'renterInfo': renterInfo,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'financials': financials,
      'deliveryConfirmedAt':
      deliveryConfirmedAt != null ? Timestamp.fromDate(deliveryConfirmedAt!) : null,
      'returnConfirmedAt':
      returnConfirmedAt != null ? Timestamp.fromDate(returnConfirmedAt!) : null,
      'reviewedByRenter': reviewedByRenter,
      'reviewedByOwner': reviewedByOwner,
      'createdAt': Timestamp.fromDate(createdAt),
      'involvedUsers': involvedUsers,
    };
    if (contract != null) {
      m['contract'] = contract!.toMap();
    }
    return m;
  }
}
