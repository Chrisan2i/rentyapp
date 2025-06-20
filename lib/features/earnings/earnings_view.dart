// ARCHIVO: lib/features/earnings/earnings_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart';
import 'package:rentyapp/features/auth/models/payout_destination_model.dart';
import 'package:rentyapp/core/controllers/wallet_controller.dart';
import 'package:rentyapp/features/earnings/widgets/deposit_funds_sheet.dart';
import 'package:rentyapp/features/earnings/widgets/earnings_stats_grid.dart';
import 'package:rentyapp/features/earnings/widgets/earnings_summary_card.dart';
import 'package:rentyapp/features/earnings/widgets/recent_transactions_list.dart';
import 'package:rentyapp/features/earnings/widgets/withdraw_funds_sheet.dart';
import 'package:rentyapp/features/auth/models/transaction_model.dart';

class EarningsView extends StatefulWidget {
  final bool openDepositSheet;
  final bool openWithdrawSheet;

  const EarningsView({
    super.key,
    this.openDepositSheet = false,
    this.openWithdrawSheet = false,
  });

  @override
  State<EarningsView> createState() => _EarningsViewState();
}

class _EarningsViewState extends State<EarningsView> {
  @override
  void initState() {
    super.initState();
    // La lógica de abrir los modales se moverá al `build` para tener acceso al
    // `context` y al `controller` de forma segura.
  }

  @override
  Widget build(BuildContext context) {
    // Leemos el WalletController que fue proveído globalmente en main.dart
    final controller = context.watch<WalletController>();

    // Usamos WidgetsBinding para abrir los modales después de que la UI se construya.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) { // Verificamos si el widget sigue en el árbol
        if (widget.openDepositSheet) {
          _showDepositSheet(context, controller);
        }
        if (widget.openWithdrawSheet) {
          _showWithdrawSheet(context, controller);
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('My Wallet', style: AppTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.fetchWalletData(),
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Permite el refresh incluso si no hay scroll
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const EarningsSummaryCard(), // Este puede ser estático por ahora
              const SizedBox(height: 24),

              // Grid de Estadísticas con FutureBuilder para carga dinámica
              FutureBuilder<Map<String, dynamic>>(
                future: controller.walletStats,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                  }
                  final stats = snapshot.data ?? {};
                  return EarningsStatsGrid(
                    paid: stats['paid'] ?? 0,
                    pending: stats['pending'] ?? 0,
                    withdrawn: stats['withdrawn'] ?? 0,
                    available: stats['available'] ?? 0,
                  );
                },
              ),
              const SizedBox(height: 24),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      label: 'Deposit',
                      icon: Icons.add_card,
                      onPressed: () => _showDepositSheet(context, controller),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      label: 'Withdraw',
                      icon: Icons.north_east,
                      onPressed: () => _showWithdrawSheet(context, controller),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Lista de Transacciones con FutureBuilder
              FutureBuilder<List<TransactionModel>>(
                future: controller.userTransactions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink(); // No muestra nada mientras carga
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No transactions yet.", style: AppTextStyles.subtitle));
                  }
                  return RecentTransactionsList(transactions: snapshot.data!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required String label, required IconData icon, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.button.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showWithdrawSheet(BuildContext context, WalletController controller) {
    controller.walletStats.then((stats) {
      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => WithdrawFundsSheet(
            availableBalance: stats['available'] ?? 0.0,
            payoutMethods: controller.payoutMethods,
          ),
        );
      }
    });
  }

  void _showDepositSheet(BuildContext context, WalletController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DepositFundsSheet(paymentMethods: controller.paymentMethods),
    );
  }
}