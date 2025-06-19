// lib/models/product_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// ----- PricingDetails no cambia, lo omito por brevedad -----
// lib/models/pricing_details.dart (o como lo llames)

class PricingDetails {
  final double? perDay;
  final double? perWeek;
  final double? perMonth;

  PricingDetails({this.perDay, this.perWeek, this.perMonth});

  // --- ¡ESTE ES EL MÉTODO MÁS IMPORTANTE! ---
  // "Traduce" el mapa de Firestore a un objeto Dart.
  factory PricingDetails.fromMap(Map<String, dynamic> map) {
    return PricingDetails(
      // Busca la clave 'day' en el mapa que viene de Firestore.
      perDay: (map['day'] as num?)?.toDouble(),
      // Busca la clave 'week'.
      perWeek: (map['week'] as num?)?.toDouble(),
      // Busca la clave 'month'.
      perMonth: (map['month'] as num?)?.toDouble(),
    );
  }

  // Lógica inteligente para mostrar el precio y la unidad correctos.
  double get displayPrice {
    return perDay ?? perWeek ?? perMonth ?? 0.0;
  }

  String get displayUnit {
    if (perDay != null) return 'day';
    if (perWeek != null) return 'week';
    if (perMonth != null) return 'month';
    return 'day'; // Valor por defecto
  }

  // Este método es para escribir de vuelta a Firestore.
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
  final double depositAmount;
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
    this.depositAmount = 0.0,
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
      'rating': rating,
      'totalReviews': totalReviews,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}