import 'package:cloud_firestore/cloud_firestore.dart';
// lib/models/rental_request_model.dart

class RentalRequestModel {
  final String requestId;
  final String status; // 'pending', 'accepted', 'rejected', 'expired'
  final String productId;
  final String ownerId;
  final String renterId;
  final DateTime startDate;
  final DateTime endDate;
  final String messageToOwner;

  // Desglose Financiero
  final Map<String, double> financials;

  final DateTime createdAt;
  final DateTime expiresAt;

  RentalRequestModel({
    required this.requestId,
    required this.status,
    required this.productId,
    required this.ownerId,
    required this.renterId,
    required this.startDate,
    required this.endDate,
    required this.messageToOwner,
    required this.financials,
    required this.createdAt,
    required this.expiresAt,
  });

  factory RentalRequestModel.fromMap(Map<String, dynamic> map, String id) {
    return RentalRequestModel(
      requestId: id,
      status: map['status'] ?? 'pending',
      productId: map['productId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      renterId: map['renterId'] ?? '',
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      messageToOwner: map['messageToOwner'] ?? '',
      financials: (map['financials'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(key, (value as num).toDouble())),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      expiresAt: (map['expiresAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'productId': productId,
      'ownerId': ownerId,
      'renterId': renterId,
      'startDate': startDate,
      'endDate': endDate,
      'messageToOwner': messageToOwner,
      'financials': financials,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
    };
  }
}