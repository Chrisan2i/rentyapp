import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentyapp/core/widgets/cloudinary_service.dart';

class AddPhotosStep extends StatelessWidget {
  final List<String> photos; // Cloudinary URLs
  final void Function(String url) onAddPhoto;
  final void Function(String url) onRemovePhoto;

  const AddPhotosStep({
    super.key,
    required this.photos,
    required this.onAddPhoto,
    required this.onRemovePhoto,
  });

  Future<void> _handlePickAndUpload(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);

    if (picked != null) {
      final url = await CloudinaryService.uploadImage(picked);
      if (url != null) {
        onAddPhoto(url);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
        }
      }
    }
  }

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

        GestureDetector(
          onTap: photos.length >= 5
              ? null
              : () => _handlePickAndUpload(context),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: photos.isEmpty
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_a_photo_outlined, size: 36, color: Colors.white70),
                  SizedBox(height: 12),
                  Text('Add Photos', style: TextStyle(color: Colors.white)),
                  SizedBox(height: 6),
                  Text('JPG, PNG (up to 5MB)',
                      style: TextStyle(color: Color(0xFF999999), fontSize: 12)),
                ],
              )
                  : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: photos
                    .map(
                      (url) => Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () => onRemovePhoto(url),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Photo Tips:\n• Use natural lighting\n• Show all angles\n• Make it clear and tidy',
            style: TextStyle(color: Color(0xFF999999), fontSize: 12),
          ),
        ),
        if (photos.length >= 5)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Max. 5 images allowed',
              style: TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
