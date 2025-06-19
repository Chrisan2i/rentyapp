// ARCHIVO: lib/features/profile/widgets/profile_details.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha de forma más limpia
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';

class ProfileDetails extends StatelessWidget {
  final UserModel user;
  const ProfileDetails({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Formateador de fecha para reutilizar
    final DateFormat formatter = DateFormat('MMMM d, yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Profile Details', style: AppTextStyles.statCompactTitle),
        const SizedBox(height: 12),
        _buildDetailTile(Icons.email, 'Email', user.email),
        // <<<--- CORRECCIÓN: Manejo de valor nulo para el teléfono ---<<<
        _buildDetailTile(Icons.phone, 'Phone', user.phone ?? 'Not provided'),
        _buildDetailTile(Icons.calendar_today, 'Joined', formatter.format(user.createdAt)),
        _buildDetailTile(Icons.login, 'Last Login', formatter.format(user.lastLoginAt)),
      ],
    );
  }

  Widget _buildDetailTile(IconData icon, String value, String label) {
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
