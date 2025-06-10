class RentalModel {
  final String rentalId;
  final String itemId;
  final String renterId;
  final String ownerId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final String status;
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
  });

  Map<String, dynamic> toJson() => {
    'rentalId': rentalId,
    'itemId': itemId,
    'renterId': renterId,
    'ownerId': ownerId,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'totalPrice': totalPrice,
    'status': status,
    'reviewedByRenter': reviewedByRenter,
    'reviewedByOwner': reviewedByOwner,
    'createdAt': createdAt.toIso8601String(),
  };

  factory RentalModel.fromJson(Map<String, dynamic> json) => RentalModel(
    rentalId: json['rentalId'],
    itemId: json['itemId'],
    renterId: json['renterId'],
    ownerId: json['ownerId'],
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    status: json['status'],
    reviewedByRenter: json['reviewedByRenter'],
    reviewedByOwner: json['reviewedByOwner'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  RentalModel copyWith({
    String? rentalId,
    String? itemId,
    String? renterId,
    String? ownerId,
    DateTime? startDate,
    DateTime? endDate,
    double? totalPrice,
    String? status,
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

