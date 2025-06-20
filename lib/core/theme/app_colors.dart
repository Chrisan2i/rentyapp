// ARCHIVO: lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0085FF);
  static const Color background = Color(0xFF0B0B0B);
  static const Color textSecondary = Color(0xFF999999);
  static const Color white = Colors.white;
  static const Color surface = Color(0xFF1A1A1A);

  // Colores con opacidad definidos
  static const Color white70 = Colors.white70;
  static const Color white30 = Color.fromRGBO(255, 255, 255, 0.3); // <<<--- AÑADIDO: Para iconos menos prominentes
  static const Color white10 = Color.fromRGBO(255, 255, 255, 0.1);

  // Colores de estado
  static const Color success = Color(0xFF2ED573); // <<<--- AÑADIDO: Un verde para estados de éxito
  static const Color warning = Color(0xFFFFA502); // <<<--- AÑADIDO: Un naranja/ámbar para advertencias
  static const Color error = Colors.redAccent;
  static const Color danger = Color(0xFFFF4757);

  // Otros colores
  static const Color notificationDot = Colors.red;
  static const Color card = Color(0xFF333333);
  static const Color inputBorder = Color(0xFF2C2C2C);
  static const Color hint = Color(0xFF666666);
  static const Color textFieldLabel = Color(0xFFCCCCCC);
}