// lib/features/landing/widgets/header_logo_and_notification.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/controllers/controller.dart';
import 'package:rentyapp/features/notifications/notification_view.dart';

class HeaderLogoAndNotification extends StatelessWidget {
  const HeaderLogoAndNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = context.watch<AppController>(); // watch para redibujar si cambia

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/rentyapp.png',
          height: 45,
          fit: BoxFit.contain,
        ),
        StreamBuilder<int>(
          stream: appController.unreadNotificationsCountStream,
          initialData: 0,
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;

            return Stack(
              alignment: Alignment.topRight,
              children: [
                GestureDetector(
                  // <<<--- 2. ACTUALIZA EL MÉTODO onTap ---<<<
                  onTap: () {
                    // Navega a la pantalla de notificaciones
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none, color: AppColors.white),
                  ),
                ),
                if (count > 0)
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