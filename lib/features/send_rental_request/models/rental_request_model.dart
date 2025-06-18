import 'package:cloud_firestore/cloud_firestore.dart';

class RentalRequestModel {
  final String requestId;
  final String productId;
  final String ownerId;
  final String renterId;
  final Timestamp startDate;
  final Timestamp endDate;
  final int daysRequested;
  final String message;
  final String paymentMethod;
  final String status;
  final Timestamp createdAt;
  final Timestamp? respondedAt;

  // ✅ Nuevos campos financieros
  final double pricePerDay;
  final double subtotal;
  final double vat;
  final double total;

  RentalRequestModel({
    required this.requestId,
    required this.productId,
    required this.ownerId,
    required this.renterId,
    required this.startDate,
    required this.endDate,
    required this.daysRequested,
    required this.message,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.pricePerDay,
    required this.subtotal,
    required this.vat,
    required this.total,
    this.respondedAt,
  });

  factory RentalRequestModel.fromMap(Map<String, dynamic> map, String id) {
    return RentalRequestModel(
      requestId: id,
      productId: map['productId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      renterId: map['renterId'] ?? '',
      startDate: map['startDate'] ?? Timestamp.now(),
      endDate: map['endDate'] ?? Timestamp.now(),
      daysRequested: map['daysRequested'] ?? 0,
      message: map['message'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      respondedAt: map['respondedAt'],
      pricePerDay: (map['pricePerDay'] as num?)?.toDouble() ?? 0.0,
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      vat: (map['vat'] as num?)?.toDouble() ?? 0.0,
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'ownerId': ownerId,
      'renterId': renterId,
      'startDate': startDate,
      'endDate': endDate,
      'daysRequested': daysRequested,
      'message': message,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt,
      'respondedAt': respondedAt,
      'pricePerDay': pricePerDay,
      'subtotal': subtotal,
      'vat': vat,
      'total': total,
    };
  }
}