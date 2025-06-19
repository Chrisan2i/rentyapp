// ARCHIVO: lib/features/profile/widgets/profile_header_bar.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/core/controllers/controller.dart';

class ProfileHeaderBar extends StatelessWidget {
  const ProfileHeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    // <<<--- CORRECCIÓN: Se usa AppController, y solo se necesita para la acción ---<<<
    final controller = context.read<AppController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Profile', style: AppTextStyles.headline.copyWith(letterSpacing: 0.3)),
        // <<<--- MEJORA: Usar StreamBuilder para el contador de notificaciones ---<<<
        StreamBuilder<int>(
          stream: controller.unreadNotificationsCountStream,
          initialData: 0,
          builder: (context, snapshot) {
            final notificationCount = snapshot.data ?? 0;
            return Stack(
              alignment: Alignment.topRight,
              children: [
                GestureDetector(
                  // <<<--- CORRECCIÓN: El método se llama clearAllNotifications ---<<<
                  onTap: controller.clearAllNotifications,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none, color: AppColors.white),
                  ),
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.notificationDot,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.background, width: 1),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}