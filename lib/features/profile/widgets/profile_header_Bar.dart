// lib/features/profile/widgets/profile_header_bar.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/controllers/controller.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/settings/settings_view.dart';

class ProfileHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileHeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ✨ MEJORA: Texto en español
          Text('Perfil', style: AppTextStyles.headline.copyWith(letterSpacing: 0.3)),
          Row(
            children: [
              _buildIconButton(
                context: context,
                icon: Icons.settings_outlined,
                tooltip: 'Configuración', // ✨ MEJORA: Tooltip para accesibilidad
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsView()));
                },
              ),
              const SizedBox(width: 8),
              StreamBuilder<int>(
                stream: controller.unreadNotificationsCountStream,
                initialData: 0,
                builder: (context, snapshot) {
                  final notificationCount = snapshot.data ?? 0;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildIconButton(
                        context: context,
                        icon: Icons.notifications_none_outlined,
                        tooltip: 'Notificaciones',
                        onTap: controller.clearAllNotifications,
                      ),
                      if (notificationCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
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
      ),
    );
  }

  // Helper para crear los botones de icono de forma consistente.
  Widget _buildIconButton({required BuildContext context, required IconData icon, required String tooltip, required VoidCallback onTap}) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}