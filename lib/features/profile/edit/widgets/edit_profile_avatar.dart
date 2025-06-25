// lib/features/profile/widgets/edit_profile_avatar.dart

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:rentyapp/core/theme/app_colors.dart';

class EditProfileAvatar extends StatelessWidget {
  final File? imageFile;
  final String imageUrl;
  final String userName; // Se necesita para las iniciales de fallback
  final VoidCallback onTap;

  const EditProfileAvatar({
    super.key,
    required this.imageFile,
    required this.imageUrl,
    required this.userName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider backgroundImage;
    if (imageFile != null) {
      backgroundImage = FileImage(imageFile!);
    } else {
      backgroundImage = NetworkImage(imageUrl);
    }

    // Obtener iniciales para el fallback
    final initials = userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : '?';

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.surface, // Color de fondo para el fallback
            onBackgroundImageError: (exception, stackTrace) {
              // Maneja el error si la NetworkImage falla
              debugPrint('Failed to load profile image: $exception');
            },
            backgroundImage: backgroundImage,
            // ✨ MEJORA: Fallback profesional si la imagen no carga
            child: (imageFile == null && (imageUrl.isEmpty || imageUrl.contains('placeholder')))
                ? Text(initials, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white))
                : null,
          ),
          // ✨ MEJORA: Overlay para indicar que se puede editar
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
              child: const Icon(Icons.edit, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}