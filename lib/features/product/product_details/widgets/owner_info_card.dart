// lib/features/product/widgets/owner_info_card.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';
import '../../../../core/widgets/custom_network_image.dart';
import 'section_card.dart';

/// A card displaying information about the item's owner.
/// Includes a placeholder state for loading.
class OwnerInfoCard extends StatelessWidget {
  final UserModel? ownerInfo;
  final bool isPlaceholder;

  /// Creates a card with the owner's information.
  const OwnerInfoCard({
    super.key,
    required this.ownerInfo,
  }) : isPlaceholder = false;

  /// Creates a placeholder version of the card, used during data loading.
  /// This pattern prevents layout shifts.
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
              child: CustomNetworkImage(
                imageUrl: owner.profileImageUrl,
                fit: BoxFit.cover,
                width: 48,
                height: 48,
                placeholder: (context) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                ),
                errorWidget: (context, error) => Center(
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
            const Icon(Icons.verified, color: AppColors.primary, size: 24),
        ],
      ),
    );
  }

  /// Builds the placeholder skeleton for the card.
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