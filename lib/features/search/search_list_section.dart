// lib/features/search/widgets/product_list_section.dart
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

  Stream<List<ProductModel>> fetchProductsStream() {
    // Empezamos con la consulta base
    Query productsQuery = FirebaseFirestore.instance.collection('products').where('isAvailable', isEqualTo: true);

    // 1. Aplicar filtro de búsqueda por texto (requiere un campo de búsqueda en minúsculas en Firestore)
    if (searchQuery.isNotEmpty) {
      productsQuery = productsQuery
          .where('title_lowercase', isGreaterThanOrEqualTo: searchQuery.toLowerCase())
          .where('title_lowercase', isLessThanOrEqualTo: '${searchQuery.toLowerCase()}\uf8ff');
    }

    // 2. Aplicar filtro de categoría
    if (filters['category'] != null) {
      productsQuery = productsQuery.where('category', isEqualTo: filters['category']);
    }

    // 3. Aplicar filtros de rango de precio (solo si ambos valores están presentes)
    if (filters['minPrice'] != null) {
      productsQuery = productsQuery.where('rentalPrices.perDay', isGreaterThanOrEqualTo: filters['minPrice']);
    }
    if (filters['maxPrice'] != null) {
      productsQuery = productsQuery.where('rentalPrices.perDay', isLessThanOrEqualTo: filters['maxPrice']);
    }

    // 4. Aplicar ordenamiento
    if (filters['sortBy'] == 'price_asc') {
      productsQuery = productsQuery.orderBy('rentalPrices.perDay', descending: false);
    } else if (filters['sortBy'] == 'price_desc') {
      productsQuery = productsQuery.orderBy('rentalPrices.perDay', descending: true);
    } else {
      // Orden por defecto: relevancia (si hay búsqueda) o fecha de creación
      productsQuery = productsQuery.orderBy('createdAt', descending: true);
    }

    return productsQuery.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductModel>>(
      key: ValueKey('$searchQuery-${filters.toString()}'),
      stream: fetchProductsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: AppColors.primary)));
        }
        if (snapshot.hasError) {
          debugPrint('Error en Firestore: ${snapshot.error}');
          return SliverToBoxAdapter(child: Center(child: Text('Ocurrió un error al cargar.', style: TextStyle(color: AppColors.error))));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text('No se encontraron productos.\nIntenta ajustar tu búsqueda o filtros.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.white70, fontSize: 16)),
              ),
            ),
          );
        }

        final products = snapshot.data!;

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 16.0, mainAxisSpacing: 16.0, childAspectRatio: 0.68,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onViewProduct: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product)));
                },
              );
            },
          ),
        );
      },
    );
  }
}