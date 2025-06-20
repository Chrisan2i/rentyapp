// ARCHIVO: lib/features/profile/widgets/account_info_section.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para el portapapeles
import 'package:intl/intl.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';

class AccountInfoSection extends StatelessWidget {
  final UserModel user;
  const AccountInfoSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MMMM d, yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Account Information', style: AppTextStyles.statCompactTitle),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.white10),
          ),
          child: Column(
            children: [
              _buildInfoTile(context, 'Email', user.email, Icons.email_outlined),
              const Divider(height: 1, color: AppColors.white10, indent: 56),
              _buildInfoTile(context, 'Phone', user.phone ?? 'Not provided', Icons.phone_outlined),
              const Divider(height: 1, color: AppColors.white10, indent: 56),
              _buildInfoTile(context, 'Joined Date', formatter.format(user.createdAt), Icons.calendar_today_outlined),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildInfoTile(BuildContext context, String label, String value, IconData icon, {bool canCopy = false}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.white70, size: 22),
      title: Text(label, style: AppTextStyles.subtitle.copyWith(fontSize: 12)),
      subtitle: Text(value, style: AppTextStyles.inputLabel.copyWith(color: AppColors.white, fontWeight: FontWeight.normal), maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: canCopy ?
      // CORRECCIÓN: Se quitó 'const' porque onPressed es una función, no un valor constante.
      IconButton(
        icon: const Icon(Icons.copy_outlined, size: 18, color: AppColors.white30),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: value));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User ID copied to clipboard')),
          );
        },
      ) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    );
  }
}