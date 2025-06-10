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
    productId: json['productId'],
    ownerId: json['ownerId'],
    title: json['title'],
    description: json['description'],
    category: json['category'],
    rentalPrices: Map<String, double>.from(json['rentalPrices'] ?? {}),
    images: List<String>.from(json['images']),
    isAvailable: json['isAvailable'],
    rating: (json['rating'] ?? 0).toDouble(),
    totalReviews: json['totalReviews'],
    views: json['views'] ?? 0,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    location: Map<String, dynamic>.from(json['location']),
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
    final data = doc.data() as Map<String, dynamic>?; // Make data nullable
    if (data == null) {
      // Handle the case where document data is null (shouldn't happen often if exists is true)
      print("Warning: Document data is null for doc ID: ${doc.id}");
      return ProductModel(
        productId: doc.id, // Use doc ID as productId fallback
        ownerId: '',
        title: 'Producto no disponible',
        description: '',
        category: '',
        rentalPrices: {},
        images: [],
        isAvailable: false,
        rating: 0.0,
        totalReviews: 0,
        views: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        location: {},
      );
    }

    // A veces, createdAt y updatedAt pueden venir como Timestamp si no se guardaron como String
    // Tu código asume String. Si en Firestore son Timestamps, necesitas adaptarlo.
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

    return ProductModel(
      productId: data['productId'] ?? doc.id, // Usa doc.id como fallback si productId no está en el doc
      ownerId: data['ownerId'] ?? '',
      title: data['title'] ?? 'Sin título',
      description: data['description'] ?? '',
      category: data['category'] ?? 'General',
      // Asegura que rentalPrices y location sean mapas, incluso si vienen nulos
      rentalPrices: Map<String, double>.from(data['rentalPrices'] ?? {}),
      images: List<String>.from(data['images'] ?? []), // Asegura que images sea una lista de strings
      isAvailable: data['isAvailable'] ?? true,
      rating: _getDoubleFromDynamic(data['rating']),
      totalReviews: data['totalReviews'] ?? 0,
      views: data['views'] ?? 0,
      createdAt: parsedCreatedAt ?? DateTime.now(),
      updatedAt: parsedUpdatedAt ?? DateTime.now(),
      location: Map<String, dynamic>.from(data['location'] ?? {}),
    );
  }

  // Función auxiliar para manejar 'int' o 'double' para la calificación
  static double _getDoubleFromDynamic(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      return 0.0; // Valor predeterminado si no es int ni double
    }
  }
}