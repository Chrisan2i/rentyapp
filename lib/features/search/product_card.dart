import 'package:flutter/material.dart';
import 'package:rentyapp/features/product/product_model.dart'; // <--- Ajusta la ruta si es diferente

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onViewProduct;
  final VoidCallback onRentNow;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onViewProduct,
    required this.onRentNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 426, // ANCHO FIJO ORIGINAL
      height: 114, // ALTO FIJO ORIGINAL
      decoration: ShapeDecoration(
        color: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Colors.white.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                // Usa un placeholder si la lista de imágenes está vacía o la URL es inválida
                image: NetworkImage(
                  product.images.isNotEmpty && product.images[0].isNotEmpty
                      ? product.images[0]
                      : 'https://placehold.co/80x80?text=No+Image', // Fallback con texto
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 16),
          // Product Info (Título, Ubicación, Precio)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center, // <-- OJO: Tuvo esta línea en una versión anterior, pero no en la que muestra el error específico del Column de botones. La dejo comentada por si la habías quitado.
              children: [
                Text(
                  product.title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  maxLines: 1, // Limita a una línea
                  overflow: TextOverflow.ellipsis, // Muestra "..."
                ),
                Text(
                  // Acceso seguro a los datos de ubicación
                  '${product.location['city'] ?? 'Ciudad desconocida'}, ${product.location['neighborhood'] ?? 'Sector desconocido'}',
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  // Acceso seguro al precio de alquiler
                  '\$${product.rentalPrices['day']?.toStringAsFixed(2) ?? 'N/A'} /day',
                  style: const TextStyle(color: Color(0xFF0085FF), fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Rating and Buttons (View and Rent Now)
          Column( // Este es el Column que el error indica que tiene overflow
            // mainAxisAlignment: MainAxisAlignment.center, // <-- Si tu error viene de esta línea, descomentala
            children: [
              Text(
                product.rating.toStringAsFixed(1), // Muestra 0.0, 4.5, etc.
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 8), // ESPACIADO ORIGINAL
              GestureDetector(
                onTap: onViewProduct,
                child: Container(
                  width: 52,
                  height: 28,
                  decoration: ShapeDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Center(
                    child: Text(
                      'View',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4), // ESPACIADO ORIGINAL
              GestureDetector(
                onTap: onRentNow,
                child: Container(
                  width: 79,
                  height: 28,
                  decoration: const ShapeDecoration(
                    color: Color(0xFF0085FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  child: const Center(
                    child: Text(
                      'Rent Now',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}