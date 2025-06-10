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

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 400;

    return Container(
      // Adjusted horizontal margins to be smaller
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 12, // Reduced from 12 to 8 for small screens, and 16 to 12 for larger
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1,
          color: Colors.white.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image/Placeholder
            _buildProductImage(),
            SizedBox(width: isSmallScreen ? 12 : 16),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title and Rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 8),
                      _buildRating(),
                    ],
                  ),

                  // Location
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${product.location['city'] as String? ?? 'Ciudad Desconocida'}, '
                          '${product.location['neighborhood'] as String? ?? 'Sector Desconocido'}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Price
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '\$${product.rentalPrices['day']?.toStringAsFixed(2) ?? 'N/A'} /day',
                      style: const TextStyle(
                        color: Color(0xFF0085FF),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: isSmallScreen ? 8 : 16),

            // Buttons
            _buildActionButtons(isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        image: (product.images.isNotEmpty && product.images[0].isNotEmpty)
            ? DecorationImage(
          image: NetworkImage(product.images[0]),
          fit: BoxFit.cover,
        )
            : null,
      ),
      child: (product.images.isEmpty || product.images[0].isEmpty)
          ? Center(
        child: Text(
          _getProductTypeAbbreviation(product.title),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          color: Colors.white.withOpacity(0.8),
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          product.rating.toStringAsFixed(1),
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isSmallScreen) {
    final buttonWidth = isSmallScreen ? 60.0 : 70.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // View Button
        InkWell(
          onTap: onViewProduct,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: buttonWidth,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'View',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Rent Now Button
        InkWell(
          onTap: onRentNow,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: buttonWidth,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF0085FF),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0085FF).withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Rent Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getProductTypeAbbreviation(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('taladro') || lowerTitle.contains('drill')) {
      return 'Drill';
    } else if (lowerTitle.contains('carpa') || lowerTitle.contains('tent')) {
      return 'Tent';
    } else if (lowerTitle.contains('guitarra') || lowerTitle.contains('guitar')) {
      return 'Guitar';
    }

    if (title.isNotEmpty) {
      final words = title.split(' ');
      if (words.isNotEmpty && words[0].length <= 6) {
        return words[0];
      }
    }
    return 'Item';
  }
}