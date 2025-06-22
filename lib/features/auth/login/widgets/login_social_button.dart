// lib/features/auth/login/widgets/login_social_button.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class LoginSocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const LoginSocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.white10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            // <<<--- SOLUCIÓN AL OVERFLOW ---<<<
            // Flexible permite que el texto se encoja si no hay suficiente espacio.
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.loginButton,
                overflow: TextOverflow.ellipsis, // Si aún así es muy largo, añade "..."
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}