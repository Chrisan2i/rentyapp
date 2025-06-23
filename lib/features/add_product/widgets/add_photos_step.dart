// lib/features/add_product/widgets/add_photos_step.dart

import 'package:flutter/material.dart';

class AddPhotosStep extends StatelessWidget {
  /// La lista de URLs de imágenes ya subidas.
  final List<String> photos;

  /// Una función ASÍNCRONA que se llamará cuando el usuario quiera añadir una foto.
  /// Esta función no recibe parámetros. El widget padre se encarga de todo.
  final Future<void> Function() onAddPhoto;

  /// Una función que se llama para eliminar una foto, pasando su URL.
  final void Function(String url) onRemovePhoto;

  const AddPhotosStep({
    super.key,
    required this.photos,
    required this.onAddPhoto, // La firma ahora coincide
    required this.onRemovePhoto,
  });

  // <<<--- SE ELIMINÓ EL MÉTODO _handlePickAndUpload ---<<<
  // La lógica ahora vive en el widget padre (AddProductView), que es lo correcto.

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Add Photos',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'Add high-quality photos to showcase your item',
          style: TextStyle(color: Color(0xFF999999), fontSize: 14),
        ),
        const SizedBox(height: 24),

        // El widget que se puede tocar para añadir fotos.
        GestureDetector(
          // Si hay 5 o más fotos, se deshabilita el onTap.
          // Si no, al tocar, se llama directamente a la función `onAddPhoto` del padre.
          onTap: photos.length >= 5 ? null : onAddPhoto,
          child: Container(
            width: double.infinity, // Ocupa el ancho disponible
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
            'Photo Tips:\n• Use natural lighting\n• Show all angles\n• Make it clear and tidy',
            style: TextStyle(color: Color(0xFF999999), fontSize: 12, height: 1.5),
          ),
        ),
        if (photos.length >= 5)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'Maximum of 5 images reached.',
              style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  /// El estado que se muestra cuando no hay ninguna foto.
  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.add_a_photo_outlined, size: 36, color: Colors.white70),
        SizedBox(height: 12),
        Text('Add Photos', style: TextStyle(color: Colors.white)),
        SizedBox(height: 6),
        Text(
          'JPG, PNG (up to 5 images)',
          style: TextStyle(color: Color(0xFF999999), fontSize: 12),
        ),
      ],
    );
  }

  /// El grid que muestra las fotos ya subidas.
  Widget _buildPhotosGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: photos.map((url) => _buildPhotoThumbnail(url)).toList(),
    );
  }

  /// Un thumbnail de una sola foto con su botón para eliminar.
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
            // Placeholder mientras carga la imagen
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade800,
                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            },
            // En caso de error al cargar la imagen
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 80,
                height: 80,
                color: Colors.red.shade900,
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