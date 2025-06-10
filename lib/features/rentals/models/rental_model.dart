enum RentalStatus { ongoing, completed, cancelled }

class RentalModel {
  final String rentalId;
  final String itemId;
  final String renterId;
  final String ownerId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final RentalStatus status;
  final bool reviewedByRenter;
  final bool reviewedByOwner;
  final DateTime createdAt;

  RentalModel({
    required this.rentalId,
    required this.itemId,
    required this.renterId,
    required this.ownerId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.reviewedByRenter,
    required this.reviewedByOwner,
    required this.createdAt,
  }) {
    // Validación: La fecha de finalización no debe ser anterior a la fecha de inicio
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('La fecha de fin no puede ser anterior a la fecha de inicio.');
    }
  }

  Map<String, dynamic> toJson() => {
    'rentalId': rentalId,
    'itemId': itemId,
    'renterId': renterId,
    'ownerId': ownerId,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'totalPrice': totalPrice,
    'status': status.toString().split('.').last,  // Convierte el enum a String
    'reviewedByRenter': reviewedByRenter,
    'reviewedByOwner': reviewedByOwner,
    'createdAt': createdAt.toIso8601String(),
  };

  factory RentalModel.fromJson(Map<String, dynamic> json) {
    return RentalModel(
      rentalId: json['rentalId'],
      itemId: json['itemId'],
      renterId: json['renterId'],
      ownerId: json['ownerId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      status: RentalStatus.values.firstWhere(
            (e) => e.toString() == 'RentalStatus.' + json['status'],
        orElse: () => RentalStatus.ongoing,  // Valor predeterminado
      ),
      reviewedByRenter: json['reviewedByRenter'],
      reviewedByOwner: json['reviewedByOwner'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  RentalModel copyWith({
    String? rentalId,
    String? itemId,
    String? renterId,
    String? ownerId,
    DateTime? startDate,
    DateTime? endDate,
    double? totalPrice,
    RentalStatus? status,
    bool? reviewedByRenter,
    bool? reviewedByOwner,
    DateTime? createdAt,
  }) {
    return RentalModel(
      rentalId: rentalId ?? this.rentalId,
      itemId: itemId ?? this.itemId,
      renterId: renterId ?? this.renterId,
      ownerId: ownerId ?? this.ownerId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      reviewedByRenter: reviewedByRenter ?? this.reviewedByRenter,
      reviewedByOwner: reviewedByOwner ?? this.reviewedByOwner,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

