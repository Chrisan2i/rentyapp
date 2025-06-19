// lib/features/landing/widgets/explore_button.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/core/controllers/controller.dart'; // <<<--- CORREGIDO a AppController

class ExploreButton extends StatelessWidget {
  const ExploreButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // <<<--- CORRECCIÓN: Llamamos al método correcto en AppController ---<<<
      // Suponiendo que el índice de la página de exploración es 1
      onPressed: () => context.read<AppController>().setSelectedIndex(1),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Center(
        child: Text('Start Exploring', style: AppTextStyles.button),
      ),
    );
  }
}