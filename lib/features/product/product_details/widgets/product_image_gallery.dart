import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';

/// Muestra la imagen principal del producto con un placeholder.
class ProductImageGallery extends StatelessWidget {
  final List<String> images;

  const ProductImageGallery({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        height: 250,
        width: double.infinity,
        color: AppColors.surface,
        child: images.isNotEmpty
            ? Image.network(
          images[0],
          fit: BoxFit.cover,
          errorBuilder: (c, o, s) => _buildImagePlaceholder(),
        )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return const Center(
      child: Text(
        'Drill',
        style: TextStyle(
          color: AppColors.white,
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}