import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String productId;
  final String ownerId;
  final String title;
  final String description;
  final String category;
  final Map<String, double> rentalPrices;
  final List<String> images;
  final bool isAvailable;
  final double rating;
  final int totalReviews;
  final int views;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> location;

  ProductModel({
    required this.productId,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.category,
    required this.rentalPrices,
    required this.images,
    required this.isAvailable,
    required this.rating,
    required this.totalReviews,
    required this.views,
    required this.createdAt,
    required this.updatedAt,
    required this.location,
  });

  // Constructor para crear un ProductModel con valores por defecto o "vacío"
  // Esto es útil cuando un documento de Firestore no existe o no se puede parsear.
  ProductModel.empty(String id) :
        productId = id,
        ownerId = '',
        title = 'Producto no disponible', // Título de fallback
        description = '',
        category = '',
        rentalPrices = {},
        images = [],
        isAvailable = false,
        rating = 0.0,
        totalReviews = 0,
        views = 0,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        location = {};

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'ownerId': ownerId,
    'title': title,
    'description': description,
    'category': category,
    'rentalPrices': rentalPrices,
    'images': images,
    'isAvailable': isAvailable,
    'rating': rating,
    'totalReviews': totalReviews,
    'views': views,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'location': location,
  };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    productId: json['productId'] as String? ?? '',
    ownerId: json['ownerId'] as String? ?? '',
    title: json['title'] as String? ?? 'Sin título',
    description: json['description'] as String? ?? '',
    category: json['category'] as String? ?? 'General',
    rentalPrices: (json['rentalPrices'] as Map<String, dynamic>?)?.map((key, value) => MapEntry(key, _getDoubleFromDynamic(value))) ?? {},
    images: List<String>.from(json['images'] as List<dynamic>? ?? []),
    isAvailable: json['isAvailable'] as bool? ?? true,
    rating: _getDoubleFromDynamic(json['rating']),
    totalReviews: json['totalReviews'] as int? ?? 0,
    views: json['views'] as int? ?? 0,
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
    location: Map<String, dynamic>.from(json['location'] as Map<String, dynamic>? ?? {}),
  );

  ProductModel copyWith({
    String? productId,
    String? ownerId,
    String? title,
    String? description,
    String? category,
    Map<String, double>? rentalPrices,
    List<String>? images,
    bool? isAvailable,
    double? rating,
    int? totalReviews,
    int? views,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? location,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      rentalPrices: rentalPrices ?? this.rentalPrices,
      images: images ?? this.images,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      views: views ?? this.views,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      location: location ?? this.location,
    );
  }

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists || doc.data() == null) {
      // Usar el constructor .empty que hemos definido
      return ProductModel.empty(doc.id);
    }

    final data = doc.data() as Map<String, dynamic>;

    DateTime? parsedCreatedAt;
    if (data['createdAt'] is Timestamp) {
      parsedCreatedAt = (data['createdAt'] as Timestamp).toDate();
    } else if (data['createdAt'] is String) {
      parsedCreatedAt = DateTime.tryParse(data['createdAt']);
    }

    DateTime? parsedUpdatedAt;
    if (data['updatedAt'] is Timestamp) {
      parsedUpdatedAt = (data['updatedAt'] as Timestamp).toDate();
    } else if (data['updatedAt'] is String) {
      parsedUpdatedAt = DateTime.tryParse(data['updatedAt']);
    }

    Map<String, double> parsedRentalPrices = {};
    if (data['rentalPrices'] is Map) {
      (data['rentalPrices'] as Map).forEach((key, value) {
        if (value is num) {
          parsedRentalPrices[key.toString()] = value.toDouble();
        }
      });
    }

    Map<String, dynamic> parsedLocation = {};
    if (data['location'] is Map) {
      parsedLocation = Map<String, dynamic>.from(data['location']);
    }

    return ProductModel(
      productId: data['productId'] as String? ?? doc.id,
      ownerId: data['ownerId'] as String? ?? '',
      title: data['title'] as String? ?? 'Producto Desconocido',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? 'Otros',
      rentalPrices: parsedRentalPrices,
      images: List<String>.from(data['images'] as List<dynamic>? ?? []),
      isAvailable: data['isAvailable'] as bool? ?? true,
      rating: _getDoubleFromDynamic(data['rating']),
      totalReviews: data['totalReviews'] as int? ?? 0,
      views: data['views'] as int? ?? 0,
      createdAt: parsedCreatedAt ?? DateTime.now(),
      updatedAt: parsedUpdatedAt ?? DateTime.now(),
      location: parsedLocation,
    );
  }

  static double _getDoubleFromDynamic(dynamic value) {
    if (value is num) {
      return value.toDouble();
    } else {
      return 0.0;
    }
  }
}