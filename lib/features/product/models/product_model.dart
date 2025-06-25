// lib/models/product_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';


class PricingDetails {
  final double? perDay;
  final double? perWeek;
  final double? perMonth;

  PricingDetails({this.perDay, this.perWeek, this.perMonth});

  factory PricingDetails.fromMap(Map<String, dynamic> map) {
    return PricingDetails(
      perDay: (map['day'] as num?)?.toDouble(),
      perWeek: (map['week'] as num?)?.toDouble(),
      perMonth: (map['month'] as num?)?.toDouble(),
    );
  }


  double get displayPrice {
    return perDay ?? perWeek ?? perMonth ?? 0.0;
  }

  String get displayUnit {
    if (perDay != null) return 'day';
    if (perWeek != null) return 'week';
    if (perMonth != null) return 'month';
    return 'day'; // Valor por defecto
  }
  // --- FIN DE LA SOLUCIÓN ---

  Map<String, dynamic> toMap() {
    return {
      if (perDay != null) 'day': perDay,
      if (perWeek != null) 'week': perWeek,
      if (perMonth != null) 'month': perMonth,
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
  final double securityDeposit; // ¡CAMBIO! Renombrado de 'depositAmount'
  final int minimumRentalDays;
  final int maximumRentalDays;
  final List<Map<String, DateTime>> rentedPeriods;
  final Map<String, dynamic> location;
  final String ownerId;
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
    this.securityDeposit = 0.0, // ¡CAMBIO!
    this.minimumRentalDays = 1,
    this.maximumRentalDays = 90,
    this.rentedPeriods = const [],
    required this.location,
    required this.ownerId,
    this.rating = 0.0,
    this.totalReviews = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  // El resto del modelo (fromMap, toMap, _parseTimestamp) se mantiene igual
  // pero ahora usa 'securityDeposit' en lugar de 'depositAmount'.
  // ... (Aquí iría el resto del código del modelo que ya me proporcionaste,
  // con el cambio de nombre aplicado en fromMap y toMap)

  static DateTime _parseTimestamp(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    if (dateValue is Timestamp) return dateValue.toDate();
    if (dateValue is String) return DateTime.tryParse(dateValue) ?? DateTime.now();
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
      // ¡CAMBIO! Lee el campo nuevo, con fallback al antiguo por si tienes datos viejos.
      securityDeposit: (map['securityDeposit'] as num?)?.toDouble() ?? (map['depositAmount'] as num?)?.toDouble() ?? 0.0,
      minimumRentalDays: map['minimumRentalDays'] as int? ?? 1,
      maximumRentalDays: map['maximumRentalDays'] as int? ?? 90,
      rentedPeriods: (map['rentedPeriods'] as List<dynamic>? ?? []).map((p) {
        final periodMap = p as Map<String, dynamic>;
        return {'start': _parseTimestamp(periodMap['start']), 'end': _parseTimestamp(periodMap['end'])};
      }).toList(),
      location: Map<String, dynamic>.from(map['location'] ?? {}),
      ownerId: map['ownerId'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: map['totalReviews'] as int? ?? 0,
      createdAt: _parseTimestamp(map['createdAt']),
      updatedAt: _parseTimestamp(map['updatedAt']),
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
      'securityDeposit': securityDeposit, // ¡CAMBIO!
      'minimumRentalDays': minimumRentalDays,
      'maximumRentalDays': maximumRentalDays,
      'rentedPeriods': rentedPeriods.map((p) => {'start': Timestamp.fromDate(p['start']!), 'end': Timestamp.fromDate(p['end']!)}).toList(),
      'location': location,
      'ownerId': ownerId,
      'rating': rating,
      'totalReviews': totalReviews,
      'createdAt': FieldValue.serverTimestamp(), // Mejor usar serverTimestamp al escribir
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}