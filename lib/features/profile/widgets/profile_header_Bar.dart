// ARCHIVO: lib/features/profile/widgets/profile_header_bar.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/controllers/controller.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/settings/settings_view.dart';

class ProfileHeaderBar extends StatelessWidget {
  const ProfileHeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Profile', style: AppTextStyles.headline.copyWith(letterSpacing: 0.3)),
        Row(
          children: [
            // MEJORA: El botón de Configuración ahora es un IconButton aquí,
            // una ubicación más estándar y limpia.
            _buildIconButton(
              icon: Icons.settings_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsView()),
                );
              },
            ),
            const SizedBox(width: 8),
            StreamBuilder<int>(
              stream: controller.unreadNotificationsCountStream,
              initialData: 0,
              builder: (context, snapshot) {
                final notificationCount = snapshot.data ?? 0;
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    _buildIconButton(
                      icon: Icons.notifications_none,
                      onTap: controller.clearAllNotifications,
                    ),
                    if (notificationCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.notificationDot,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.background, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        )
      ],
    );
  }

  // Helper para crear los botones de icono de forma consistente.
  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: AppColors.white10,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 22),
      ),
    );
  }
}