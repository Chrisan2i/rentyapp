import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';

/// Un botón con estilo de texto reutilizable para acciones como "Ver más".
class DetailsTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const DetailsTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.hint.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}