// lib/features/profile/widgets/profile_header.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/core/widgets/custom_network_image.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  const ProfileHeader({super.key, required this.user});

  // ✨ MEJORA: Textos de verificación en español
  String _getVerificationText(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.level1_basic:
        return 'Verificado Nivel 1';
      case VerificationStatus.level2_plus:
        return 'Verificado Plus';
      case VerificationStatus.notVerified:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userInitials = user.fullName.isNotEmpty ? user.fullName.split(' ').map((e) => e[0]).take(2).join() : '?';
    final String verificationText = _getVerificationText(user.verificationStatus);
    final String userBio = "Nómada digital explorando el mundo. Apasionado por la tecnología y la fotografía.";

    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: AppColors.surface,
          child: ClipOval(
            child: CustomNetworkImage(
              imageUrl: user.profileImageUrl,
              fit: BoxFit.cover,
              width: 96,
              height: 96,
              placeholder: (context) => const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
              errorWidget: (context, error) => Center(
                child: Text(
                  userInitials,
                  style: const TextStyle(fontSize: 40, color: AppColors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
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
            // ✨ MEJORA: Texto en español
            Text('(${user.totalReviews} reseñas)', style: AppTextStyles.subtitle),
          ],
        ),
        const SizedBox(height: 16),
        if (userBio.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              userBio,
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
          ),
        const SizedBox(height: 20),
        if (verificationText.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified, color: AppColors.primary, size: 14),
                const SizedBox(width: 6),
                Text(
                  verificationText,
                  style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
      ],
    );
  }
}