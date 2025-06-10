import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentyapp/features/product/product_model.dart'; // <--- Ajusta la ruta si es diferente
import 'package:rentyapp/features/search/product_card.dart';   // <--- Ajusta la ruta si es diferente

class ProductListSection extends StatelessWidget {
  const ProductListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: fetchProducts(), // Llama a la función para obtener productos de Firestore
      builder: (context, snapshot) {
        // Estado: Esperando los datos
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("⌛ Cargando productos...");
          return const Center(child: CircularProgressIndicator());
        }

        // Estado: Se produjo un error al cargar los datos
        if (snapshot.hasError) {
          print('❌ Error al cargar productos: ${snapshot.error}'); // Registra el error
          return Center(
            child: Text(
              'Error al cargar productos: ${snapshot.error}', // Muestra el error
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        }

        // Estado: Datos cargados, pero no se encontraron productos o la lista está vacía
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print('ℹ️ No se encontraron productos en la base de datos.');
          return const Center(
            child: Text(
              'No products found', // El mensaje que viste en tu captura de pantalla
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        // Estado: Datos cargados exitosamente
        final products = snapshot.data!;
        print('🎉 Productos cargados: ${products.length}'); // Confirma cuántos productos se cargaron

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // Útil si ProductListSection está dentro de otro scrollable
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            // Aquí se aplica el padding alrededor de cada ProductCard.
            // Esto es lo que puede contribuir al overflow si el ProductCard tiene altura fija.
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ProductCard(
                product: product,
                onViewProduct: () {
                  // Navegar a la página de detalles del producto
                  print('Navegando a detalles del producto: ${product.title}');
                  // Aquí podrías usar Navigator.push para ir a una ProductDetailsScreen
                },
                onRentNow: () {
                  // Manejar la funcionalidad de alquilar ahora
                  print('Alquilando producto: ${product.title}');
                },
              ),
            );
          },
        );
      },
    );
  }

  // Función para obtener productos de Firestore
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products') // <--- Asegúrate de que 'products' sea el nombre exacto de tu colección
          .get();

      // Debugging: Verifica cuántos documentos se obtuvieron de Firestore
      print("🔍 Documentos de Firestore obtenidos: ${snapshot.docs.length}");

      if (snapshot.docs.isEmpty) {
        print('⚠️ No se encontraron documentos en la colección "products" de Firestore.');
        return []; // Retorna una lista vacía si no hay documentos
      }

      // Mapea los documentos a ProductModel
      return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('❌ Error al obtener productos de Firestore: $e'); // Captura cualquier error durante la obtención
      return []; // Retorna una lista vacía si hay un error
    }
  }
}