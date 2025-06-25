// lib/features/rentals/models/contract_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo para representar el Contrato Digital asociado a un alquiler.
class ContractModel {
  final String contractId;
  final String landlordId;
  final String tenantId;
  final String productId;
  final DateTime startAt;
  final DateTime endAt;
  final double price;
  final double deposit;
  final Map<String, String> placeholders;
  final String templateVersion;
  final DateTime? signedAt;
  final String contractCode;
  final String? pdfUrl;
  final String status; // pending | active | cancelled
  final DateTime createdAt;
  final DateTime updatedAt;

  ContractModel({
    required this.contractId,
    required this.landlordId,
    required this.tenantId,
    required this.productId,
    required this.startAt,
    required this.endAt,
    required this.price,
    required this.deposit,
    required this.placeholders,
    required this.templateVersion,
    this.signedAt,
    required this.contractCode,
    this.pdfUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContractModel.fromMap(Map<String, dynamic> m, String id) {
    return ContractModel(
      contractId: id,
      landlordId: m['landlordId'] as String,
      tenantId: m['tenantId'] as String,
      productId: m['productId'] as String,
      startAt: (m['startAt'] as Timestamp).toDate(),
      endAt: (m['endAt'] as Timestamp).toDate(),
      price: (m['price'] as num).toDouble(),
      deposit: (m['deposit'] as num).toDouble(),
      placeholders: Map<String, String>.from(m['placeholders'] ?? {}),
      templateVersion: m['templateVersion'] as String,
      signedAt: (m['signedAt'] as Timestamp?)?.toDate(),
      contractCode: m['contractCode'] as String,
      pdfUrl: m['pdfUrl'] as String?,
      status: m['status'] as String,
      createdAt: (m['createdAt'] as Timestamp).toDate(),
      updatedAt: (m['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'landlordId': landlordId,
    'tenantId': tenantId,
    'productId': productId,
    'startAt': Timestamp.fromDate(startAt),
    'endAt': Timestamp.fromDate(endAt),
    'price': price,
    'deposit': deposit,
    'placeholders': placeholders,
    'templateVersion': templateVersion,
    'signedAt': signedAt != null ? Timestamp.fromDate(signedAt!) : null,
    'contractCode': contractCode,
    'pdfUrl': pdfUrl,
    'status': status,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };
}

