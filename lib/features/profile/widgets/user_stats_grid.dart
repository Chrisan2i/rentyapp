// ARCHIVO: lib/features/profile/widgets/user_stats_grid.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';

class UserStatsGrid extends StatelessWidget {
  final UserModel user;
  const UserStatsGrid({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final daysAsMember = DateTime.now().difference(user.createdAt).inDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('My Stats', style: AppTextStyles.statCompactTitle),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatCard(
              'My Listings',
              '${user.totalRentsAsOwner} items',
              Icons.list_alt,
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              'My Rentals',
              '${user.totalRentsAsRenter} items',
              Icons.shopping_bag_outlined,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatCard(
              'Reviews',
              '${user.totalReviews} total',
              Icons.reviews_outlined,
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              'Member for',
              '$daysAsMember days',
              Icons.cake_outlined,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 8),
            Text(title, style: AppTextStyles.inputLabel),
            const SizedBox(height: 2),
            Text(value, style: AppTextStyles.statCompactSubtitle.copyWith(color: AppColors.white)),
          ],
        ),
      ),
    );
  }
}