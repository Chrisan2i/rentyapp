// lib/models/review_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String reviewId;
  final String rentalId;
  final String productId;
  final String reviewerId;
  final String reviewerRole;
  final Map<String, dynamic> reviewerInfo;
  final String revieweeId; // ¡CORREGIDO! Typo en el nombre de la variable
  final double rating;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.reviewId,
    required this.rentalId,
    required this.productId,
    required this.reviewerId,
    required this.reviewerRole,
    required this.reviewerInfo,
    required this.revieweeId, // ¡CORREGIDO!
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  // --- ¡NUEVO! Getters para acceder fácilmente a la información del usuario ---
  /// Extrae el nombre del usuario desde el mapa `reviewerInfo`.
  /// Devuelve 'Usuario Anónimo' si no se encuentra.
  String get userName => reviewerInfo['name'] as String? ?? 'Usuario Anónimo';

  /// Extrae la URL de la imagen del usuario desde `reviewerInfo`.
  /// Devuelve una cadena vacía si no se encuentra.
  String get userImageUrl => reviewerInfo['imageUrl'] as String? ?? '';


  // --- ¡NUEVO! Constructor `fromFirestore` para facilitar la creación desde un DocumentSnapshot ---
  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      reviewId: doc.id,
      rentalId: data['rentalId'] ?? '',
      productId: data['productId'] ?? '',
      reviewerId: data['reviewerId'] ?? '',
      reviewerRole: data['reviewerRole'] ?? '',
      reviewerInfo: Map<String, dynamic>.from(data['reviewerInfo'] ?? {}),
      revieweeId: data['revieweeId'] ?? '', // ¡CORREGIDO!
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  // Tu constructor `fromMap` original, por si lo usas en otro lado (lo he corregido también)
  factory ReviewModel.fromMap(Map<String, dynamic> map, String id) {
    return ReviewModel(
      reviewId: id,
      rentalId: map['rentalId'] ?? '',
      productId: map['productId'] ?? '',
      reviewerId: map['reviewerId'] ?? '',
      reviewerRole: map['reviewerRole'] ?? '',
      reviewerInfo: Map<String, dynamic>.from(map['reviewerInfo'] ?? {}),
      revieweeId: map['revieweeId'] ?? '', // ¡CORREGIDO!
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      comment: map['comment'] ?? '',
      createdAt: (map['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rentalId': rentalId,
      'productId': productId,
      'reviewerId': reviewerId,
      'reviewerRole': reviewerRole,
      'reviewerInfo': reviewerInfo,
      'revieweeId': revieweeId, // ¡CORREGIDO!
      'rating': rating,
      'comment': comment,
      'createdAt': FieldValue.serverTimestamp(), // Mejor usar FieldValue al escribir
    };
  }
}