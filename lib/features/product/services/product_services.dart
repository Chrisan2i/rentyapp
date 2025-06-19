// lib/features/product/services/product_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Asegúrate que las rutas de importación son correctas para tu proyecto
import 'package:rentyapp/features/product/models/product_model.dart';
import 'package:rentyapp/features/product/models/review_model.dart';

/// Un objeto para encapsular el resultado de una consulta paginada de productos.
/// Esto permite a la UI saber si hay más páginas para cargar.
class ProductQueryResult {
  final List<ProductModel> products;
  final DocumentSnapshot? lastDocument; // El último documento de la página actual

  ProductQueryResult({required this.products, this.lastDocument});

  bool get hasMore => products.isNotEmpty && lastDocument != null;
}


class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Crea una referencia a la colección 'products' con un conversor.
  // Esto hace que todas las operaciones sean tipadas (type-safe) y más limpias.
  CollectionReference<ProductModel> get _productsRef {
    return _db.collection('products').withConverter<ProductModel>(
      fromFirestore: (snapshot, _) => ProductModel.fromMap(snapshot.data()!, snapshot.id),
      toFirestore: (model, _) => model.toMap(),
    );
  }

  // =======================================================================
  // OPERACIONES DE LECTURA (FETCHING)
  // =======================================================================

  /// Obtiene una lista de productos paginada para la pantalla principal "Explorar".
  Future<ProductQueryResult> getProducts({int limit = 10, DocumentSnapshot? startAfter}) async {
    try {
      Query<ProductModel> query = _productsRef
          .where('isAvailable', isEqualTo: true) // Solo mostrar productos disponibles
          .orderBy('createdAt', descending: true);

      // Si se proporciona un 'startAfter', comenzamos la consulta desde ese punto.
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.limit(limit).get();

      final products = snapshot.docs.map((doc) => doc.data()).toList();
      final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      return ProductQueryResult(products: products, lastDocument: lastDoc);

    } catch (e) {
      debugPrint("❌ Error al obtener productos: $e");
      rethrow; // Propaga el error para que el controlador lo maneje.
    }
  }

  /// Obtiene un único producto por su ID.
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final snapshot = await _productsRef.doc(productId).get();
      return snapshot.exists ? snapshot.data() : null;
    } catch (e) {
      debugPrint("❌ Error al obtener producto por ID: $e");
      return null;
    }
  }

  /// Obtiene todos los productos publicados por un usuario específico.
  Future<List<ProductModel>> getProductsByOwner(String ownerId) async {
    // NOTA: Para que esta consulta funcione, necesitas crear un índice compuesto en Firestore:
    // Colección: 'products', Campos: 'ownerId' (ascendente), 'createdAt' (descendente).
    try {
      final snapshot = await _productsRef
          .where('ownerId', isEqualTo: ownerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint("❌ Error al obtener productos del dueño: $e");
      return [];
    }
  }

  /// Obtiene las reseñas más recientes de un producto.
  Future<List<ReviewModel>> getProductReviews(String productId, {int limit = 5}) async {
    try {
      final snapshot = await _db
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      // Asume que tienes un ReviewModel con un factory fromMap(map, id)
      return snapshot.docs
          .map((doc) => ReviewModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint("❌ Error al obtener reseñas del producto: $e");
      return [];
    }
  }

  // =======================================================================
  // OPERACIONES DE ESCRITURA (CREATE, UPDATE, DELETE)
  // =======================================================================

  /// Crea un nuevo documento de producto en Firestore.
  Future<DocumentReference<ProductModel>> createProduct(ProductModel product) async {
    try {
      // Usamos .add() para que Firestore genere un ID único automáticamente.
      return await _productsRef.add(product);
    } catch (e) {
      debugPrint("❌ Error al crear el producto: $e");
      rethrow;
    }
  }

  /// Actualiza un producto existente en Firestore.
  /// Recibe un mapa para permitir actualizaciones parciales.
  Future<void> updateProduct(String productId, Map<String, Object?> data) async {
    try {
      await _productsRef.doc(productId).update(data);
    } catch (e) {
      debugPrint("❌ Error al actualizar el producto: $e");
      rethrow;
    }
  }

  /// Elimina un producto.
  Future<void> deleteProduct(String productId) async {
    try {
      await _productsRef.doc(productId).delete();
    } catch (e) {
      debugPrint("❌ Error al eliminar el producto: $e");
      rethrow;
    }
  }
}