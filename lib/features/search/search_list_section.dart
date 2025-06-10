import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentyapp/features/product/product_model.dart'; // <--- Adjust the path if different
import 'package:rentyapp/features/search/product_card.dart';   // <--- Adjust the path if different

class ProductListSection extends StatelessWidget {
  const ProductListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: fetchProducts(), // Calls the function to get products from Firestore
      builder: (context, snapshot) {
        // State: Waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          // print("⌛ Cargando productos..."); // Uncomment for debugging
          return const Center(child: CircularProgressIndicator());
        }

        // State: An error occurred while loading data
        if (snapshot.hasError) {
          // print('❌ Error al cargar productos: ${snapshot.error}'); // Uncomment for debugging
          return Center(
            child: Text(
              'Error al cargar productos: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        }

        // State: Data loaded, but no products found or the list is empty
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // print('ℹ️ No se encontraron productos en la base de datos.'); // Uncomment for debugging
          return const Center(
            child: Text(
              'No products found', // The message you saw in your screenshot
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        // State: Data loaded successfully
        final products = snapshot.data!;
        // print('🎉 Productos cargados: ${products.length}'); // Uncomment for debugging

        return ListView.builder(
          shrinkWrap: true,
          // If ProductListSection is inside a SingleChildScrollView or Column that is already scrollable,
          // this prevents a nested scroll error. If it's the main scroll widget, you can remove it.
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Padding(
              // The padding is already handled within ProductCard with its 'margin'
              // This padding here is extra and might make the card smaller than expected
              // or not align perfectly.
              // To make the card look like the image, the internal 'margin' of the ProductCard
              // is what defines the space between the cards.
              // I recommend removing this external Padding if the ProductCard already has margin.
              // Or leave it if you want *additional* space between the cards and the screen edges.
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0), // Adjusted to 0 horizontal if ProductCard has margin
              child: ProductCard(
                product: product,
                onViewProduct: () {
                  // Logic to navigate to the product details page
                  // print('Navegando a detalles del producto: ${product.title}'); // Uncomment for debugging
                  // Here you could use Navigator.push to go to a ProductDetailsScreen
                },
                onRentNow: () {
                  // Handle rent now functionality
                  // print('Alquilando producto: ${product.title}'); // Uncomment for debugging
                },
              ),
            );
          },
        );
      },
    );
  }

  // Function to get products from Firestore
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products') // <--- VERIFY THIS CAREFULLY IN YOUR FIREBASE CONSOLE!
          .get();

      // print("🔍 Documentos de Firestore obtenidos: ${snapshot.docs.length}"); // Uncomment for debugging

      if (snapshot.docs.isEmpty) {
        // print('⚠️ No se encontraron documentos en la colección "products" de Firestore.'); // Uncomment for debugging
        return []; // Returns an empty list if no documents are found
      }

      return snapshot.docs.map((doc) {
        try {
          return ProductModel.fromFirestore(doc);
        } catch (e) {
          // print('❌ Error al parsear documento ${doc.id}: $e'); // Uncomment for debugging
          return ProductModel.empty(doc.id); // Returns an empty model if there's an error in a specific document
        }
      }).toList();
    } catch (e) {
      // print('❌ Error general al obtener productos de Firestore: $e'); // Uncomment for debugging
      return []; // Returns an empty list if there's an error
    }
  }
}