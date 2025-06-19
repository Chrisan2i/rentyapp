// lib/models/product_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// Modelo anidado para precios
class PricingDetails {
  final double perDay;
  final double? perWeek;
  final double? perMonth;

  PricingDetails({required this.perDay, this.perWeek, this.perMonth});

  factory PricingDetails.fromMap(Map<String, dynamic> map) {
    return PricingDetails(
      perDay: (map['perDay'] as num?)?.toDouble() ?? 0.0,
      perWeek: (map['perWeek'] as num?)?.toDouble(),
      perMonth: (map['perMonth'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'perDay': perDay,
      if (perWeek != null) 'perWeek': perWeek,
      if (perMonth != null) 'perMonth': perMonth,
    };
  }
}

class ProductModel {
  final String productId;
  final String title;
  final String description;
  final String category;
  final List<String> images;
  final bool isAvailable;

  // Precios y Reglas de Alquiler
  final PricingDetails rentalPrices;
  final double depositAmount;
  final int minimumRentalDays;
  final int maximumRentalDays;

  // Disponibilidad y Ubicación
  final List<Map<String, DateTime>> rentedPeriods;
  final Map<String, dynamic> location;

  // Información del Dueño (Denormalizada)
  final String ownerId;
  final Map<String, dynamic> ownerInfo;

  // Reputación y Estadísticas
  final double rating;
  final int totalReviews;

  // Metadatos
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.productId,
    required this.title,
    required this.description,
    required this.category,
    required this.images,
    required this.isAvailable,
    required this.rentalPrices,
    this.depositAmount = 0.0,
    this.minimumRentalDays = 1,
    this.maximumRentalDays = 90,
    this.rentedPeriods = const [],
    required this.location,
    required this.ownerId,
    required this.ownerInfo,
    this.rating = 0.0,
    this.totalReviews = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      productId: id,
      title: map['title'] ?? 'Sin título',
      description: map['description'] ?? '',
      category: map['category'] ?? 'General',
      images: List<String>.from(map['images'] ?? []),
      isAvailable: map['isAvailable'] ?? true,
      rentalPrices: PricingDetails.fromMap(map['rentalPrices'] ?? {}),
      depositAmount: (map['depositAmount'] as num?)?.toDouble() ?? 0.0,
      minimumRentalDays: map['minimumRentalDays'] as int? ?? 1,
      maximumRentalDays: map['maximumRentalDays'] as int? ?? 90,
      rentedPeriods: (map['rentedPeriods'] as List<dynamic>? ?? []).map((p) {
        return {
          'start': (p['start'] as Timestamp).toDate(),
          'end': (p['end'] as Timestamp).toDate(),
        };
      }).toList(),
      location: Map<String, dynamic>.from(map['location'] ?? {}),
      ownerId: map['ownerId'] ?? '',
      ownerInfo: Map<String, dynamic>.from(map['ownerInfo'] ?? {}),
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: map['totalReviews'] as int? ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'images': images,
      'isAvailable': isAvailable,
      'rentalPrices': rentalPrices.toMap(),
      'depositAmount': depositAmount,
      'minimumRentalDays': minimumRentalDays,
      'maximumRentalDays': maximumRentalDays,
      'rentedPeriods': rentedPeriods,
      'location': location,
      'ownerId': ownerId,
      'ownerInfo': ownerInfo,
      'rating': rating,
      'totalReviews': totalReviews,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
