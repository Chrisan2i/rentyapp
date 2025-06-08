import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';

class ProfileDetails extends StatelessWidget {
  final UserModel user;
  const ProfileDetails({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Profile Details', style: AppTextStyles.statCompactTitle),
        const SizedBox(height: 12),
        _buildDetailTile(Icons.email, 'Email', user.email),
        _buildDetailTile(Icons.phone, 'Phone', user.phone),
        _buildDetailTile(Icons.calendar_today, 'Joined', user.createdAt.toLocal().toString().split(' ')[0]),
        _buildDetailTile(Icons.login, 'Last Login', user.lastLoginAt.toLocal().toString().split(' ')[0]),
      ],
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white10),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surface,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.white70),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.inputLabel),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.statCompactSubtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
