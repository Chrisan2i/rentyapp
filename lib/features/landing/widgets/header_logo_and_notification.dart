// lib/features/landing/widgets/header_logo_and_notification.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/controllers/controller.dart'; // <<<--- CORREGIDO a AppController

class HeaderLogoAndNotification extends StatelessWidget {
  const HeaderLogoAndNotification({super.key});

  @override
  Widget build(BuildContext context) {
    // <<<--- CORRECCIÓN: Usamos AppController ---<<<
    final appController = context.read<AppController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/rentyapp.png', // Asegúrate que esta ruta es correcta
          height: 45,
          fit: BoxFit.contain,
        ),
        // <<<--- MEJORA: Usamos StreamBuilder para datos en tiempo real ---<<<
        StreamBuilder<int>(
          // Nos suscribimos al stream de notificaciones no leídas del controlador
          stream: appController.unreadNotificationsCountStream,
          initialData: 0, // Mostramos 0 mientras el stream se inicializa
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;

            return Stack(
              alignment: Alignment.topRight,
              children: [
                GestureDetector(
                  // Llamamos al método correcto en AppController
                  onTap: () => appController.clearAllNotifications(),
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
                // El punto rojo solo aparece si el contador es mayor que 0
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