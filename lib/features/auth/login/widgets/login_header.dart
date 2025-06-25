// lib/features/auth/login/widgets/login_header.dart
import 'package:flutter/material.dart';
// import 'package:rentyapp/core/theme/app_colors.dart'; // Ya no es necesario
import 'package:rentyapp/core/theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- CÓDIGO ADAPTADO ---
        // Se reemplaza el CircleAvatar por el widget Image.asset
        Image.asset(
          'assets/rentyapp.png', // Asegúrate de que la ruta a tu logo sea correcta
          width: 180, // Puedes ajustar el ancho a tu gusto
        ),
        // --- FIN DE LA ADAPTACIÓN ---

        const SizedBox(height: 32), // Aumenté un poco el espacio para que respire mejor

        const Text(
          'Bienvenido de nuevo', // Texto actualizado a español
          style: AppTextStyles.loginTitle,
        ),

        const SizedBox(height: 8),

        const Text(
          'Inicia sesión para alquilar o publicar tus artículos', // Texto actualizado a español
          style: AppTextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}