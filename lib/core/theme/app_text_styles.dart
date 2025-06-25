// lib/core/theme/app_text_styles.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // --- Títulos y Encabezados ---
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle headlinePrimary = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle loginTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle bannerTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  // --- Texto General y Subtítulos ---
  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle bannerSubtitle = TextStyle(
    fontSize: 14,
    color: AppColors.white70,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.white70,
    height: 1.5, // Un buen interlineado mejora la legibilidad
  );

  // --- Botones y Acciones ---
  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle loginButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle bannerAction = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  // --- Formularios y Entradas ---
  static const TextStyle inputLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textFieldLabel,
  );

  static const TextStyle inputHint = TextStyle(
    color: AppColors.hint,
  );

  static const TextStyle errorText = TextStyle(
    color: AppColors.error,
  );

  // --- Estadísticas ---
  static const TextStyle statTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle statSubtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle statCompactTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle statCompactSubtitle = TextStyle(
    fontSize: 12,
    color: AppColors.white70,
  );

  // --- UI Específica (Categorías, Navegación) ---
  static const TextStyle categoryEmoji = TextStyle(
    fontSize: 28,
  );

  static const TextStyle categoryLabel = TextStyle(
    color: AppColors.white,
    fontSize: 14,
  );

  static const TextStyle categoryChip = TextStyle(
    color: AppColors.white,
    fontSize: 14,
  );

  static const TextStyle navBarLabel = TextStyle(
    fontSize: 12,
    color: AppColors.white70,
  );

  static const TextStyle navBarLabelSelected = TextStyle(
    fontSize: 12,
    color: AppColors.primary,
  );

  static const TextStyle quickAccessLabel = TextStyle(
    fontSize: 12,
    color: AppColors.white70,
  );

  // <<<--- SOLUCIÓN: Aquí añadimos el estilo que faltaba ---<<<
  static const TextStyle small = TextStyle(
    fontSize: 12,
    color: AppColors.white,
  );

  // --- Misceláneos ---
  static const TextStyle white70 = TextStyle(
    color: AppColors.white70,
  );
}