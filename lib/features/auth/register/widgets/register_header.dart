// lib/features/auth/register/widgets/register_header.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Únete a Renty',
              style: AppTextStyles.loginTitle, // Reutilizando un estilo adecuado
            ),
            SizedBox(height: 10),
            Text(
              "El principal mercado de alquileres en Venezuela",
              style: AppTextStyles.subtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}