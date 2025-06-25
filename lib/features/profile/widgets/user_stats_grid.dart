// lib/features/profile/widgets/user_stats_grid.dart

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
        // ✨ MEJORA: Texto en español
        const Text('Mis Estadísticas', style: AppTextStyles.statCompactTitle),
        const SizedBox(height: 12),
        Row(
          children: [
            // ✨ MEJORA: Textos en español
            _buildStatCard(
              'Mis Publicaciones',
              '${user.totalRentsAsOwner} ítems',
              Icons.list_alt,
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              'Mis Alquileres',
              '${user.totalRentsAsRenter} ítems',
              Icons.shopping_bag_outlined,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatCard(
              'Reseñas',
              '${user.totalReviews} totales',
              Icons.reviews_outlined,
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              'Miembro por',
              '$daysAsMember días',
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
            // ✨ MEJORA: Ícono con fondo para mayor impacto visual.
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(height: 8),
            Text(title, style: AppTextStyles.subtitle.copyWith(fontSize: 12)),
            const SizedBox(height: 2),
            Text(value, style: AppTextStyles.statCompactSubtitle.copyWith(color: AppColors.white)),
          ],
        ),
      ),
    );
  }
}