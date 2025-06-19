// lib/features/product/widgets/product_list_section.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart'; // Asumiendo ruta correcta
import 'package:rentyapp/features/product/models/product_model.dart';
import 'package:rentyapp/features/product/product_details/product_details_view.dart'; // Asumiendo ruta correcta
import 'product_card.dart';

class ProductListSection extends StatelessWidget {
  final String searchQuery;
  final Map<String, dynamic> filters;

  const ProductListSection({
    super.key,
    required this.searchQuery,
    required this.filters,
  });

  Future<List<ProductModel>> fetchProducts(String query, Map<String, dynamic> activeFilters) async {
    try {
      Query productsQuery = FirebaseFirestore.instance.collection('products').where('isAvailable', isEqualTo: true);

      // Búsqueda por texto (requiere un índice en Firestore o un campo en minúsculas)
      if (query.isNotEmpty) {
        productsQuery = productsQuery
            .where('title_lowercase', isGreaterThanOrEqualTo: query.toLowerCase())
            .where('title_lowercase', isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff');
      }

      // --- CORREGIDO AQUÍ ---
      // Se ordena por el campo correcto en Firestore: 'rentalPrices.perDay'.
      if (activeFilters['sortBy'] == 'price_asc') {
        productsQuery = productsQuery.orderBy('rentalPrices.perDay');
      } else if (activeFilters['sortBy'] == 'price_desc') {
        productsQuery = productsQuery.orderBy('rentalPrices.perDay', descending: true);
      } else {
        // Orden por defecto si no se especifica uno (ej. por fecha de creación)
        productsQuery = productsQuery.orderBy('createdAt', descending: true);
      }

      final QuerySnapshot snapshot = await productsQuery.get();

      // --- CORREGIDO AQUÍ ---
      // Se utiliza el constructor factory correcto 'ProductModel.fromMap' que
      // recibe el mapa de datos y el ID del documento.
      return snapshot.docs.map((doc) {
        // Hacemos un cast seguro de los datos a Map<String, dynamic>
        final data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromMap(data, doc.id);
      }).toList();

    } catch (e) {
      // ignore: avoid_print
      print('❌ Error al obtener productos de Firestore: $e');
      // Es mejor relanzar una excepción más específica o manejarla aquí.
      throw Exception('Failed to load products.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      key: ValueKey('$searchQuery-${filters.toString()}'),
      future: fetchProducts(searchQuery, filters),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: AppColors.error)));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found.', style: TextStyle(color: AppColors.white70, fontSize: 16)));
        }
        final products = snapshot.data!;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 16.0, mainAxisSpacing: 16.0, childAspectRatio: 0.68, // Ajustado para el nuevo layout
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onViewProduct: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product)),
                );
              },
              onRentNow: () {
                // ignore: avoid_print
                print('Rent product: ${product.title}');
                // Aquí podrías navegar a la pantalla de reserva pasando el producto.
              },
            );
          },
        );
      },
    );
  }
}