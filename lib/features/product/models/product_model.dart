// lib/models/product_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// ----- PricingDetails no cambia, lo omito por brevedad -----
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
  final PricingDetails rentalPrices;
  final double depositAmount;
  final int minimumRentalDays;
  final int maximumRentalDays;
  final List<Map<String, DateTime>> rentedPeriods;
  final Map<String, dynamic> location;
  final String ownerId;
  final Map<String, dynamic> ownerInfo;
  final double rating;
  final int totalReviews;
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

  // --- ¡AQUÍ ESTÁ LA MAGIA! ---
  // Función de ayuda para convertir de forma segura cualquier formato de fecha.
  static DateTime _parseTimestamp(dynamic dateValue) {
    if (dateValue == null) {
      return DateTime.now(); // O manejarlo como un error, dependiendo de tu lógica.
    }
    if (dateValue is Timestamp) {
      return dateValue.toDate();
    }
    if (dateValue is String) {
      // Intenta parsear la String. Si falla, devuelve ahora.
      return DateTime.tryParse(dateValue) ?? DateTime.now();
    }
    // Si es otro tipo, devuelve ahora como fallback.
    return DateTime.now();
  }

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

      // Usamos nuestra función de ayuda aquí
      rentedPeriods: (map['rentedPeriods'] as List<dynamic>? ?? []).map((p) {
        final periodMap = p as Map<String, dynamic>;
        return {
          'start': _parseTimestamp(periodMap['start']),
          'end': _parseTimestamp(periodMap['end']),
        };
      }).toList(),

      location: Map<String, dynamic>.from(map['location'] ?? {}),
      ownerId: map['ownerId'] ?? '',
      ownerInfo: Map<String, dynamic>.from(map['ownerInfo'] ?? {}),
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: map['totalReviews'] as int? ?? 0,

      // Y también la usamos aquí
      createdAt: _parseTimestamp(map['createdAt']),
      updatedAt: _parseTimestamp(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    // Tu método toMap está perfecto. Lo dejamos como está.
    // El SDK se encarga de convertir DateTime a Timestamp.
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
      // Convertimos DateTime a Timestamp para Firestore
      'rentedPeriods': rentedPeriods.map((p) => {
        'start': Timestamp.fromDate(p['start']!),
        'end': Timestamp.fromDate(p['end']!),
      }).toList(),
      'location': location,
      'ownerId': ownerId,
      'ownerInfo': ownerInfo,
      'rating': rating,
      'totalReviews': totalReviews,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}