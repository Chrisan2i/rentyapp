// ARCHIVO: lib/features/earnings/widgets/earnings_stats_grid.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class EarningsStatsGrid extends StatelessWidget {
  final double paid, pending, withdrawn, available;
  const EarningsStatsGrid({
    super.key,
    required this.paid,
    required this.pending,
    required this.withdrawn,
    required this.available,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: [
        _buildStatCard('Paid', paid, AppColors.success),
        _buildStatCard('Pending', pending, AppColors.warning),
        _buildStatCard('Withdrawn', withdrawn, AppColors.white70),
        _buildStatCard('Available', available, AppColors.primary),
      ],
    );
  }

  Widget _buildStatCard(String title, double amount, Color dotColor) {
    final formatCurrency = NumberFormat.simpleCurrency(decimalDigits: 2, name: '\$');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.subtitle),
            ],
          ),
          const SizedBox(height: 8),
          Text(formatCurrency.format(amount), style: AppTextStyles.sectionTitle.copyWith(fontSize: 18)),
        ],
      ),
    );
  }
}