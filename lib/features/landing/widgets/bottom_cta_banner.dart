// lib/features/landing/widgets/bottom_cta_banner.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/add_product/view/add_product_view.dart';

class BottomCtaBanner extends StatelessWidget {
  const BottomCtaBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on_outlined, size: 32, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Gana Dinero con Tus Cosas', style: AppTextStyles.bannerTitle),
                SizedBox(height: 4),
                Text(
                  'Publica lo que no usas y genera ingresos extra hoy mismo.',
                  style: AppTextStyles.bannerSubtitle,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductView()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: const Text('Publicar'),
          )
        ],
      ),
    );
  }
}