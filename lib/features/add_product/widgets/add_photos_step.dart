// lib/features/add_product/widgets/add_photos_step.dart
import 'package:flutter/material.dart';

class AddPhotosStep extends StatelessWidget {
  final List<String> photos;
  final Future<void> Function() onAddPhoto;
  final void Function(String url) onRemovePhoto;

  const AddPhotosStep({
    super.key,
    required this.photos,
    required this.onAddPhoto,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          // TRADUCCIÓN:
          'Añadir Fotos',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          // TRADUCCIÓN:
          'Muestra tu artículo con fotos de alta calidad.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF999999), fontSize: 14),
        ),
        const SizedBox(height: 24),

        GestureDetector(
          onTap: photos.length >= 5 ? null : onAddPhoto,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 160),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: photos.isEmpty
                ? _buildEmptyState()
                : _buildPhotosGrid(),
          ),
        ),

        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            // TRADUCCIÓN:
            'Consejos para las fotos:\n• Usa luz natural y un fondo limpio\n• Muestra el artículo desde todos los ángulos\n• Destaca cualquier detalle o imperfección',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF999999), fontSize: 12, height: 1.5),
          ),
        ),
        if (photos.length >= 5)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              // TRADUCCIÓN:
              'Se alcanzó el máximo de 5 imágenes.',
              style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.add_a_photo_outlined, size: 36, color: Colors.white70),
        SizedBox(height: 12),
        // TRADUCCIÓN:
        Text('Toca para Añadir Fotos', style: TextStyle(color: Colors.white)),
        SizedBox(height: 6),
        Text(
          // TRADUCCIÓN:
          'JPG, PNG (hasta 5 imágenes)',
          style: TextStyle(color: Color(0xFF999999), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPhotosGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: photos.map((url) => _buildPhotoThumbnail(url)).toList(),
    );
  }


  /// A thumbnail for a single photo with its remove button.
  Widget _buildPhotoThumbnail(String url) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            url,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            // Placeholder while the image is loading
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade800,
                child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
              );
            },
            // In case of an error loading the image
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.error_outline, color: Colors.white),
              );
            },
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => onRemovePhoto(url),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}