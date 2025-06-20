// lib/features/product/widgets/owner_info_card.dart

import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart'; // YA NO LO NECESITAMOS
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';
import '../../../../core/widgets/custom_network_image.dart'; // ¡IMPORTA NUESTRO WIDGET!
import 'section_card.dart';

class OwnerInfoCard extends StatelessWidget {
  // ... (el resto del widget no cambia)
  final UserModel? ownerInfo;
  final bool isPlaceholder;

  const OwnerInfoCard({
    super.key,
    required this.ownerInfo,
  }) : isPlaceholder = false;

  const OwnerInfoCard.placeholder({super.key})
      : ownerInfo = null,
        isPlaceholder = true;


  @override
  Widget build(BuildContext context) {
    if (isPlaceholder) {
      return _buildPlaceholder();
    }

    final owner = ownerInfo!;
    final String ownerInitials = owner.fullName.isNotEmpty ? owner.fullName[0].toUpperCase() : '?';

    return SectionCard(
      title: 'Owner Information',
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.surface,
            child: ClipOval(
              // --- AQUÍ ESTÁ EL CAMBIO ---
              // Usamos nuestro widget personalizado
              child: CustomNetworkImage(
                imageUrl: owner.profileImageUrl,
                fit: BoxFit.cover,
                width: 48,
                height: 48,
                // Le pasamos un placeholder personalizado
                placeholder: (context) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                ),
                // Y un error widget personalizado que muestra las iniciales
                errorWidget: (context, error) => Center(
                  child: Text(
                    ownerInitials,
                    style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          // ... el resto del widget no cambia ...
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

  // ... (el método _buildPlaceholder no cambia)
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