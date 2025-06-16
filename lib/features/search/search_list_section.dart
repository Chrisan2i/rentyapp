// lib/features/search/widgets/product_list_section.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentyapp/features/product/product_model.dart';
import 'product_card.dart'; // Usamos el ProductCard que ya tienes

class ProductListSection extends StatelessWidget {
  final String searchQuery;
  final Map<String, dynamic> filters;

  const ProductListSection({
    super.key,
    required this.searchQuery,
    required this.filters,
  });

  // La función de fetch ahora toma la consulta y los filtros como parámetros.
  Future<List<ProductModel>> fetchProducts(String query, Map<String, dynamic> activeFilters) async {
    try {
      Query productsQuery = FirebaseFirestore.instance.collection('products');

      // APLICAR FILTRO DE BÚSQUEDA (por título)
      // Firestore no soporta búsquedas "contains" nativas.
      // Esta es la forma estándar de simular una búsqueda "empieza con".
      // Para búsquedas de texto completo, se recomienda un servicio como Algolia o Typesense.
      if (query.isNotEmpty) {
        productsQuery = productsQuery
            .where('title_lowercase', isGreaterThanOrEqualTo: query.toLowerCase())
            .where('title_lowercase', isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff');
        // NOTA: Esto requiere que guardes una versión en minúsculas del título en cada documento,
        // por ejemplo, un campo `title_lowercase`.
      }

      // APLICAR OTROS FILTROS (ejemplo: ordenar por precio)
      if (activeFilters['sortBy'] == 'price_asc') {
        productsQuery = productsQuery.orderBy('rentalPrices.day', descending: false);
      } else if (activeFilters['sortBy'] == 'price_desc') {
        productsQuery = productsQuery.orderBy('rentalPrices.day', descending: true);
      }

      final QuerySnapshot snapshot = await productsQuery.get();
      return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('❌ Error al obtener productos de Firestore: $e');
      // Es una buena práctica relanzar el error para que el FutureBuilder lo atrape.
      throw Exception('Failed to load products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos `key: ValueKey` para que Flutter sepa que debe reconstruir este FutureBuilder
    // cuando la consulta de búsqueda o los filtros cambian.
    return FutureBuilder<List<ProductModel>>(
      key: ValueKey('$searchQuery-${filters.toString()}'),
      future: fetchProducts(searchQuery, filters),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No products found.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          );
        }

        final products = snapshot.data!;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            // --- AQUÍ ESTÁ EL CAMBIO ---
            // Reduce este valor para dar a la tarjeta un poco más de altura.
            childAspectRatio: 0.74, // Cambiado de 0.75 a 0.74
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onViewProduct: () {
                print('View product: ${product.title}');
              },
              onRentNow: () {
                print('Rent product: ${product.title}');
              },
            );
          },
        );
      },
    );
  }
}