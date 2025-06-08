import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class BottomCtaBanner extends StatelessWidget {
  const BottomCtaBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on, size: 32, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Earn by Renting Your Items', style: AppTextStyles.bannerTitle),
                SizedBox(height: 4),
                Text(
                  'List tools, gadgets or gear you own and start earning today.',
                  style: AppTextStyles.bannerSubtitle,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('List Now', style: AppTextStyles.bannerAction),
          )
        ],
      ),
    );
  }
}
