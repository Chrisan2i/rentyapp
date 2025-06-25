// lib/core/services/category_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentyapp/features/category/models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtiene una lista de categorías activas desde Firestore
  Future<List<Category>> getActiveCategories() async {
    try {
      // Hacemos la consulta a la colección 'categories'
      // y filtramos solo las que tienen 'isActive' en true.
      QuerySnapshot snapshot = await _firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .get();

      // Mapeamos los documentos a objetos de nuestra clase Category
      return snapshot.docs
          .map((doc) => Category.fromFirestore(doc))
          .toList();

    } catch (e) {
      // Si hay un error, lo imprimimos y retornamos una lista vacía.
      // En una app real, podrías registrar este error en un servicio como Sentry.
      print('Error al obtener categorías: $e');
      return [];
    }
  }
}