// product_card.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/features/product/product_model.dart';

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

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, color: Colors.grey[400], size: 30),
          const SizedBox(height: 4),
          Text(
            'No Photos',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 10),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onViewProduct,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Colors.white.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (product.images.isNotEmpty && product.images[0].isNotEmpty)
                      ? Image.network(
                    product.images[0],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                  )
                      : _buildImagePlaceholder(),
                ),
              ),

              // --- CAMBIO 1: Reducimos el espaciado principal ---
              const SizedBox(height: 6), // Reducido de 8 a 6

              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.location['city'] ?? 'Unknown City'}, ${product.location['neighborhood'] ?? 'Unknown Area'}',
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product.rentalPrices['day']?.toStringAsFixed(2) ?? 'N/A'} /day',
                      style: const TextStyle(color: Color(0xFF0085FF), fontSize: 16, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // --- CAMBIO 2: Reducimos el espaciado sobre el botón ---
              Padding(
                padding: const EdgeInsets.only(top: 6.0), // Reducido de 8.0 a 6.0
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    _buildRentButton(onRentNow),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRentButton(VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: ShapeDecoration(
          color: const Color(0xFF0085FF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text(
          'Rent',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}