import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/landing/controllers/controller.dart';

class HeaderLogoAndNotification extends StatelessWidget {
  const HeaderLogoAndNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<Controller>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/rentyapp.png',
          height: 45,
          fit: BoxFit.contain,
        ),
        Stack(
          alignment: Alignment.topRight,
          children: [
            GestureDetector(
              onTap: controller.clearNotifications,
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
            if (controller.notificationCount > 0)
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
        ),
      ],
    );
  }
}


