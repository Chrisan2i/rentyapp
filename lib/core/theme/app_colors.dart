// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

// Este archivo está correcto. No necesita cambios.
class AppColors {
  // Colores principales
  static const Color primary = Color(0xFF0085FF); // Azul Renty
  static const Color background = Color(0xFF0B0B0B); // Fondo principal casi negro
  static const Color surface = Color(0xFF1A1A1A); // Superficie para tarjetas y elementos elevados

  // Colores de texto
  static const Color text = Colors.white; // Texto principal (no es necesario si usas 'white')
  static const Color textSecondary = Color(0xFF999999); // Texto secundario, subtítulos

  // Colores para formularios
  static const Color textFieldLabel = Color(0xFFCCCCCC); // Etiqueta de campo de texto
  static const Color inputBorder = Color(0xFF2C2C2C); // Borde de campo de texto
  static const Color hint = Color(0xFF666666); // Texto de sugerencia (placeholder)

  // Colores de estado
  static const Color success = Color(0xFF2ED573); // Verde para éxito
  static const Color warning = Color(0xFFFFA502); // Naranja/ámbar para advertencias
  static const Color error = Colors.redAccent; // Rojo para errores de formulario
  static const Color danger = Color(0xFFFF4757); // Rojo más fuerte para acciones peligrosas

  // Colores de UI y misceláneos
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static const Color white30 = Color.fromRGBO(255, 255, 255, 0.3);
  static const Color white10 = Color.fromRGBO(255, 255, 255, 0.1);
  static const Color notificationDot = Colors.red;
  static const Color card = Color(0xFF333333); // Alternativa a 'surface' si se necesita
}