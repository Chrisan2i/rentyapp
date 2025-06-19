// lib/features/product/widgets/owner_info_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Importa el paquete recomendado
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/auth/models/user_model.dart'; // Asegúrate que la ruta al UserModel es correcta
import 'section_card.dart';

class OwnerInfoCard extends StatelessWidget {
  // --- CORRECCIÓN 1: Hacemos el modelo opcional ---
  // Ahora puede ser nulo para que el constructor placeholder funcione.
  final UserModel? ownerInfo;
  final bool isPlaceholder;

  // Constructor principal: requiere un UserModel y no es un placeholder.
  const OwnerInfoCard({
    super.key,
    required this.ownerInfo,
  }) : isPlaceholder = false;

  // --- CORRECCIÓN 2: Añadimos el constructor nombrado para el placeholder ---
  // Este constructor no recibe datos y establece `isPlaceholder` en true.
  const OwnerInfoCard.placeholder({super.key})
      : ownerInfo = null,
        isPlaceholder = true;

  @override
  Widget build(BuildContext context) {
    // Primero, renderizamos el widget esqueleto si es un placeholder.
    if (isPlaceholder) {
      return _buildPlaceholder();
    }

    // Si no es un placeholder, entonces sabemos que `ownerInfo` no es nulo.
    // Usamos '!' para asegurarle a Dart que el objeto existe.
    final owner = ownerInfo!;
    final String ownerInitials = owner.fullName.isNotEmpty ? owner.fullName[0].toUpperCase() : '?';

    // Este es el widget real que muestra los datos.
    return SectionCard(
      title: 'Owner Information',
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.surface, // Un color de fondo para el círculo
            child: ClipOval(
              // --- MEJORA: Usamos CachedNetworkImage ---
              // Es más robusto: maneja carga, errores y caché.
              child: CachedNetworkImage(
                imageUrl: owner.profileImageUrl,
                fit: BoxFit.cover,
                width: 48,
                height: 48,
                placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                errorWidget: (context, url, error) => Center(
                  child: Text(
                    ownerInitials,
                    style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  owner.fullName,
                  style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${owner.rating.toStringAsFixed(1)} Rating',
                      style: TextStyle(color: AppColors.white.withAlpha(178), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (owner.verificationStatus != VerificationStatus.notVerified)
            const Icon(Icons.verified_user, color: AppColors.primary, size: 24),
        ],
      ),
    );
  }

  /// Widget que se muestra durante el estado de carga (placeholder).
  Widget _buildPlaceholder() {
    return SectionCard(
      title: 'Owner Information',
      child: Row(
        children: [
          const CircleAvatar(radius: 24, backgroundColor: AppColors.surface),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 120, height: 14, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 8),
                Container(width: 80, height: 12, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}