// lib/features/auth/register/widgets/register_footer.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class RegisterFooter extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onRegister;

  const RegisterFooter({
    super.key,
    required this.isLoading,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: isLoading ? null : onRegister,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator(color: AppColors.white)
                  : const Text('Registrarse', style: AppTextStyles.button),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("¿Ya tienes una cuenta? ", style: AppTextStyles.subtitle),
            GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Inicia sesión', style: AppTextStyles.bannerAction),
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}