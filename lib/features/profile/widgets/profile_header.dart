// ARCHIVO: lib/features/profile/widgets/profile_header.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';
import 'package:rentyapp/features/profile/edit/edit_profile_view.dart'; // Para navegar a editar perfil

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: AppColors.surface,
          backgroundImage: NetworkImage(user.profileImageUrl),
        ),
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
            // <<<--- CORRECCIÓN: Usando el dato real del modelo ---<<<
            Text('(${user.totalReviews} reviews)', style: AppTextStyles.subtitle),
          ],
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfileView()),
            );
          },
          icon: const Icon(Icons.edit, size: 18, color: AppColors.primary),
          label: const Text('Edit Profile', style: AppTextStyles.bannerAction),
        ),
        const SizedBox(height: 16),
        // <<<--- CORRECCIÓN: Se usa el enum 'verificationStatus' del modelo ---<<<
        if (user.verificationStatus != VerificationStatus.notVerified)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              color: AppColors.primary.withOpacity(0.2),
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