import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class CategoryScroll extends StatelessWidget {
  const CategoryScroll({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['📱 Gadgets', '🏠 Home', '⛺ Camping', '💪 Fitness', '🔧 Tools'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((text) {
          final parts = text.split(' ');
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.white.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Text(parts[0], style: AppTextStyles.categoryEmoji),
                Text(parts[1], style: AppTextStyles.categoryLabel),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

