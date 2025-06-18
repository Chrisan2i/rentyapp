import 'package:flutter/material.dart';
import 'package:rentyapp/features/product/models/product_model.dart';
import 'package:rentyapp/core/theme/app_colors.dart';

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
          const Text('No Photos', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF666666), fontSize: 10)),
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
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.white10),
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
                  child: product.images.isNotEmpty
                      ? Image.network(product.images[0], fit: BoxFit.cover, width: double.infinity, errorBuilder: (c, o, s) => _buildImagePlaceholder())
                      : _buildImagePlaceholder(),
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(product.title, style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(
                      '${product.location['city'] ?? 'Ciudad'}, ${product.location['neighborhood'] ?? 'Área'}',
                      style: TextStyle(color: AppColors.white.withOpacity(0.6), fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product.rentalPrices['day']?.toStringAsFixed(2) ?? 'N/A'} /day',
                      style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.rating.toStringAsFixed(1), style: const TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w400)),
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
          color: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text('Rent', textAlign: TextAlign.center, style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }
}