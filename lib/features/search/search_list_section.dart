import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/product/models/product_model.dart';
import 'package:rentyapp/features/product/product_details/product_details_view.dart';
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

      if (query.isNotEmpty) {
        // Debes tener un campo 'title_lowercase' en Firestore para que esta búsqueda sea eficiente.
        productsQuery = productsQuery
            .where('title_lowercase', isGreaterThanOrEqualTo: query.toLowerCase())
            .where('title_lowercase', isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff');
      }

      if (activeFilters['sortBy'] == 'price_asc') {
        productsQuery = productsQuery.orderBy('rentalPrices.day');
      } else if (activeFilters['sortBy'] == 'price_desc') {
        productsQuery = productsQuery.orderBy('rentalPrices.day', descending: true);
      }

      final QuerySnapshot snapshot = await productsQuery.get();
      return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('❌ Error al obtener productos de Firestore: $e');
      throw Exception('Failed to load products: $e');
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
            crossAxisCount: 2, crossAxisSpacing: 16.0, mainAxisSpacing: 16.0, childAspectRatio: 0.74,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onViewProduct: () {
                // Aquí ocurre la magia: navegamos a la pantalla de detalles
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product)),
                );
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