// lib/features/profile/widgets/profile_actions_section.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/rentals/rental_request/rental_requests_view.dart';

class ProfileActionsSection extends StatelessWidget {
  final int pendingRequestsCount;
  final bool isVerified;

  const ProfileActionsSection({
    super.key,
    required this.pendingRequestsCount,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white10),
      ),
      child: Column(
        children: [
          // ✨ MEJORA: Textos en español
          _buildActionTile(
            icon: Icons.inbox_outlined,
            title: 'Solicitudes de Alquiler',
            trailing: _buildCountBadge(pendingRequestsCount),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RentalRequestsView()));
            },
          ),
          const Divider(height: 1, color: AppColors.white10, indent: 16, endIndent: 16),
          _buildActionTile(
            icon: Icons.list_alt_outlined,
            title: 'Mis Publicaciones',
            onTap: () { /* TODO: Navigate to My Listings */ },
          ),
          const Divider(height: 1, color: AppColors.white10, indent: 16, endIndent: 16),
          _buildActionTile(
            icon: Icons.favorite_border,
            title: 'Mis Favoritos',
            onTap: () { /* TODO: Navigate to Favorites */ },
          ),
          const Divider(height: 1, color: AppColors.white10, indent: 16, endIndent: 16),
          _buildActionTile(
            icon: Icons.verified_user_outlined,
            title: 'Verificación de Identidad',
            trailing: Text(
              isVerified ? 'Completa' : 'Pendiente',
              style: TextStyle(
                color: isVerified ? AppColors.success : AppColors.warning,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () { /* TODO: Navigate to Verification */ },
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({required IconData icon, required String title, VoidCallback? onTap, Widget? trailing}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.white70),
      title: Text(title, style: AppTextStyles.inputLabel),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) trailing,
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: AppColors.white30),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildCountBadge(int count) {
    if (count == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count.toString(),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}