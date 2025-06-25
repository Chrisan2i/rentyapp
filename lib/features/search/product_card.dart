// lib/features/search/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/features/product/models/product_model.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onViewProduct;

  const ProductCard({
    super.key,
    required this.product,
    required this.onViewProduct,
  });

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.white10,
      child: const Center(
        child: Icon(Icons.camera_alt_outlined, color: AppColors.white70, size: 40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos las propiedades inteligentes de PricingDetails
    final String displayPrice = product.rentalPrices.displayPrice.toStringAsFixed(0);
    final String displayUnit = product.rentalPrices.displayUnit; // Ya está en español

    return InkWell(
      onTap: onViewProduct,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                child: product.images.isNotEmpty
                    ? Image.network(
                  product.images.first,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (c, o, s) => _buildImagePlaceholder(),
                  loadingBuilder: (c, child, progress) {
                    if (progress == null) return child;
                    return Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2));
                  },
                )
                    : _buildImagePlaceholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: AppTextStyles.small,
                      ),
                      Text(
                        ' (${product.totalReviews})', // Muestra el número de reseñas
                        style: AppTextStyles.small.copyWith(color: AppColors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.body,
                      children: [
                        TextSpan(
                          text: '\$$displayPrice',
                          style: AppTextStyles.subtitle.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '/$displayUnit',
                          style: AppTextStyles.small.copyWith(color: AppColors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}