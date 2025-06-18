import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';

/// Un widget base para las tarjetas de sección con un título y contenido.
/// Proporciona un estilo consistente en toda la pantalla de detalles.
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets padding;

  const SectionCard({
    Key? key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}