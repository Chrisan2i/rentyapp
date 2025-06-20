// lib/models/transaction_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { rentalEarning, withdrawal, deposit, fee, refund }
enum TransactionStatus { completed, pending, failed }

class TransactionModel {
  final String transactionId;
  final String userId;
  final double amount;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime createdAt;
  final String description;
  final Map<String, dynamic> details; // Para info extra como 'rentalId', etc.

  TransactionModel({
    required this.transactionId,
    required this.userId,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.description,
    this.details = const {},
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return TransactionModel(
      transactionId: id,
      userId: map['userId'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      type: TransactionType.values.firstWhere(
            (e) => e.name == map['type'],
        orElse: () => TransactionType.rentalEarning,
      ),
      status: TransactionStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => TransactionStatus.completed,
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      description: map['description'] ?? 'N/A',
      details: Map<String, dynamic>.from(map['details'] ?? {}),
    );
  }
}