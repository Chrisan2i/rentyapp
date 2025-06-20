// ARCHIVO: lib/features/profile/widgets/wallet_summary_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/earnings/earnings_view.dart';

class WalletSummaryCard extends StatelessWidget {
  final Map<String, double> wallet;

  const WalletSummaryCard({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(decimalDigits: 2, name: '');
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
          // SECCIÓN SUPERIOR CON NAVEGACIÓN
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EarningsView()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('My Wallet', style: AppTextStyles.statCompactTitle),
                Icon(Icons.arrow_forward_ios, color: AppColors.white30, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // BALANCES
          Row(
            children: [
              _buildBalanceItem('Available', '\$${formatCurrency.format(available)}', AppColors.success),
              const SizedBox(width: 16),
              _buildBalanceItem('Pending', '\$${formatCurrency.format(pending)}', AppColors.white70),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.white10, height: 1),
          const SizedBox(height: 8),

          // <<<--- MEJORA: ACCIONES DIRECTAS DE DEPÓSITO Y RETIRO ---<<<
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                context: context,
                icon: Icons.add_card,
                label: 'Deposit',
                // Abre la vista de Wallet y luego el modal de depósito
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EarningsView(openDepositSheet: true))),
              ),
              _buildActionButton(
                context: context,
                icon: Icons.north_east,
                label: 'Withdraw',
                // Abre la vista de Wallet y luego el modal de retiro
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EarningsView(openWithdrawSheet: true))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget para los balances
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

  // Widget para los botones de acción
  Widget _buildActionButton({required BuildContext context, required IconData icon, required String label, required VoidCallback onTap}) {
    return Expanded(
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: AppColors.primary),
        label: Text(label, style: AppTextStyles.bannerAction),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}