// lib/features/product/widgets/product_image_gallery.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import '../../../../core/widgets/custom_network_image.dart';   // 2. IMPORTAMOS NUESTRO WIDGET

/// Muestra la galería de imágenes del producto (actualmente solo la primera).
class ProductImageGallery extends StatelessWidget {
  final List<String> images;

  const ProductImageGallery({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // La estructura externa no cambia en absoluto.
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Container(
        color: AppColors.surface, // Color de fondo mientras carga la imagen
        child: images.isNotEmpty
        // 3. REEMPLAZAMOS EL WIDGET
            ? CustomNetworkImage(
          imageUrl: images[0],
          fit: BoxFit.cover,
          // Le pasamos el placeholder que ya teníamos definido.
          placeholder: (context) => const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
          // Y el widget de error que ya teníamos, que es nuestro método.
          errorWidget: (context, error) => _buildImagePlaceholder(),
        )
        // Si no hay imágenes, se muestra el mismo placeholder.
            : _buildImagePlaceholder(),
      ),
    );
  }

  /// Widget que se muestra cuando no hay imagen o si la carga falla.
  /// ESTE MÉTODO NO NECESITA NINGÚN CAMBIO.
  Widget _buildImagePlaceholder() {
    return const Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.textSecondary,
        size: 60,
      ),
    );
  }
}