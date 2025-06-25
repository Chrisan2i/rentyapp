// lib/features/profile/widgets/account_info_section.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';

class AccountInfoSection extends StatelessWidget {
  final UserModel user;
  const AccountInfoSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // ✨ MEJORA: Formato de fecha localizado a español.
    final DateFormat formatter = DateFormat('d \'de\' MMMM, yyyy', 'es_ES');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✨ MEJORA: Texto en español.
        const Text('Información de la Cuenta', style: AppTextStyles.statCompactTitle),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.white10),
          ),
          child: Column(
            children: [
              // ✨ MEJORA: Textos en español y funcionalidad de copiar habilitada.
              _buildInfoTile(context, 'Correo Electrónico', user.email, Icons.email_outlined, canCopy: true),
              const Divider(height: 1, color: AppColors.white10, indent: 56),
              _buildInfoTile(context, 'Teléfono', user.phone ?? 'No proporcionado', Icons.phone_outlined),
              const Divider(height: 1, color: AppColors.white10, indent: 56),
              _buildInfoTile(context, 'Miembro desde', formatter.format(user.createdAt), Icons.calendar_today_outlined),
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
      trailing: canCopy
          ? IconButton(
        icon: const Icon(Icons.copy_outlined, size: 18, color: AppColors.white30),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: value));
          ScaffoldMessenger.of(context).showSnackBar(
            // ✨ MEJORA: Texto en español.
            SnackBar(content: Text('"$label" copiado al portapapeles')),
          );
        },
      )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    );
  }
}