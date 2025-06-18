import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/product/models/product_model.dart';

/// Muestra el encabezado del producto con título, precio y rating.
class ProductHeader extends StatelessWidget {
  final String title;
  final double pricePerDay;
  final double rating;

  const ProductHeader({
    Key? key,
    required this.title,
    required this.pricePerDay,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${pricePerDay.toStringAsFixed(0)} /day',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}