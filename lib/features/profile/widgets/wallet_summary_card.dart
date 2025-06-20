// ARCHIVO: lib/features/profile/widgets/wallet_summary_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class WalletSummaryCard extends StatelessWidget {
  final Map<String, double> wallet;

  const WalletSummaryCard({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(decimalDigits: 2, name: 'USD');
    final available = wallet['available'] ?? 0.0;
    final pending = wallet['pending'] ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('My Wallet', style: AppTextStyles.statCompactTitle),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildBalanceItem('Available Balance', formatCurrency.format(available), AppColors.success),
              const SizedBox(width: 16),
              _buildBalanceItem('Pending', formatCurrency.format(pending), AppColors.white70),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.white10),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(Icons.history, 'History', () { /* TODO: Navegar a historial */ }),
              _buildActionButton(Icons.arrow_downward, 'Deposit', () { /* TODO: Navegar a depósito */ }),
              _buildActionButton(Icons.arrow_upward, 'Withdraw', () { /* TODO: Navegar a retiro */ }),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, String amount, Color amountColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.subtitle.copyWith(fontSize: 12)),
          const SizedBox(height: 4),
          Text(amount, style: AppTextStyles.sectionTitle.copyWith(color: amountColor, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: AppColors.primary),
      label: Text(label, style: AppTextStyles.bannerAction),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}