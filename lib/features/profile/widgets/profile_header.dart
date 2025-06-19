// ARCHIVO: lib/features/profile/widgets/profile_header.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // ¡Importa el paquete!
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/user_model.dart'; // Ajusta la ruta a tu modelo
import 'package:rentyapp/features/settings/settings_view.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Para que sea más legible, obtenemos las iniciales.
    final String userInitials = user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?';

    return Column(
      children: [
        // --- INICIO DE LA CORRECCIÓN PRINCIPAL ---
        // Reemplazamos CircleAvatar con uno que usa CachedNetworkImage para robustez.
        CircleAvatar(
          radius: 48,
          backgroundColor: AppColors.surface,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: user.profileImageUrl,
              fit: BoxFit.cover,
              width: 96, // El doble del radio
              height: 96, // El doble del radio
              // Widget que se muestra mientras la imagen carga
              placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
              // Widget que se muestra si hay un error de red (como el SocketException)
              // o si la URL está vacía.
              errorWidget: (context, url, error) => Center(
                child: Text(
                  userInitials,
                  style: const TextStyle(fontSize: 40, color: AppColors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        // --- FIN DE LA CORRECCIÓN PRINCIPAL ---

        const SizedBox(height: 16),
        Text(user.fullName, style: AppTextStyles.sectionTitle),
        Text('@${user.username}', style: AppTextStyles.subtitle),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: AppColors.primary, size: 18),
            const SizedBox(width: 4),
            Text(user.rating.toStringAsFixed(1), style: AppTextStyles.inputLabel),
            const SizedBox(width: 4),
            Text('(${user.totalReviews} reviews)', style: AppTextStyles.subtitle),
          ],
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsView()),
            );
          },
          icon: const Icon(Icons.edit, size: 18, color: AppColors.primary),
          label: const Text('Settings', style: AppTextStyles.bannerAction),
        ),
        const SizedBox(height: 16),
        if (user.verificationStatus != VerificationStatus.notVerified)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              color: AppColors.primary.withAlpha(51), // Usamos withAlpha en lugar de withOpacity
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Verified User',
              style: TextStyle(color: AppColors.primary, fontSize: 12),
            ),
          ),
      ],
    );
  }
}