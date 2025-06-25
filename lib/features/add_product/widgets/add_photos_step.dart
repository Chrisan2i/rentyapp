// lib/features/add_product/widgets/add_photos_step.dart
import 'package:flutter/material.dart';

class AddPhotosStep extends StatelessWidget {
  /// The list of already uploaded image URLs.
  final List<String> photos;

  /// An ASYNC function called when the user wants to add a photo.
  /// The parent widget handles the entire upload logic.
  final Future<void> Function() onAddPhoto;

  /// A function called to remove a photo, passing its URL.
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
          'Add Photos',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'Showcase your item with high-quality photos.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF999999), fontSize: 14),
        ),
        const SizedBox(height: 24),

        // The tappable area for adding photos.
        GestureDetector(
          // Disable onTap if 5 or more photos are present.
          // Otherwise, call the `onAddPhoto` function from the parent.
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
            'Photo Tips:\n• Use natural lighting & a clean background\n• Show the item from all angles\n• Highlight any details or imperfections',
            textAlign: TextAlign.center,
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

  /// The state displayed when no photos have been added.
  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.add_a_photo_outlined, size: 36, color: Colors.white70),
        SizedBox(height: 12),
        Text('Tap to Add Photos', style: TextStyle(color: Colors.white)),
        SizedBox(height: 6),
        Text(
          'JPG, PNG (up to 5 images)',
          style: TextStyle(color: Color(0xFF999999), fontSize: 12),
        ),
      ],
    );
  }

  /// The grid that displays the uploaded photos.
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