// lib/core/models/category_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String iconUrl;
  final String slug;
  final bool isActive;

  Category({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.slug,
    required this.isActive,
  });

  // Factory constructor para crear una instancia de Category desde un documento de Firestore
  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'] ?? 'Sin Nombre',
      iconUrl: data['iconUrl'] ?? '',
      slug: data['slug'] ?? '',
      isActive: data['isActive'] ?? false,
    );
  }
}