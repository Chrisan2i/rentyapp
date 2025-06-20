// ARCHIVO: lib/features/earnings/earnings_view.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart'; // <<<--- IMPORTAR MODELO DE PAGO
import 'package:rentyapp/features/auth/models/payout_destination_model.dart';
import 'package:rentyapp/features/earnings/widgets/deposit_funds_sheet.dart'; // <<<--- IMPORTAR NUEVO WIDGET
import 'package:rentyapp/features/earnings/widgets/earnings_stats_grid.dart';
import 'package:rentyapp/features/earnings/widgets/earnings_summary_card.dart';
import 'package:rentyapp/features/earnings/widgets/recent_transactions_list.dart';
import 'package:rentyapp/features/earnings/widgets/withdraw_funds_sheet.dart';
import 'package:rentyapp/features/auth/models/transaction_model.dart';

class EarningsView extends StatefulWidget {
  // <<<--- NUEVOS PARÁMETROS ---<<<
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

  final double availableBalance = 130.00;
  final List<PayoutDestinationModel> payoutMethods = [
    PayoutDestinationModel(destinationId: '1', alias: 'Bank Account', type: 've_bank_account', destinationDetails: {'last4': '1234'}),
    PayoutDestinationModel(destinationId: '2', alias: 'PayPal', type: 'paypal', isDefault: true, destinationDetails: {'email': 'user@email.com'}),
  ];
  // <<<--- NUEVOS DATOS DE EJEMPLO PARA MÉTODOS DE PAGO ---<<<
  final List<PaymentMethodModel> paymentMethods = [
    PaymentMethodModel(paymentMethodId: 'pm_1', alias: 'Visa Debit', type: 'stripe_card', isDefault: true, providerDetails: {'last4': '4242', 'brand': 'visa'}),
    PaymentMethodModel(paymentMethodId: 'pm_2', alias: 'Mastercard Credit', type: 'stripe_card', providerDetails: {'last4': '5555', 'brand': 'mastercard'}),
  ];
  final List<TransactionModel> recentTransactions = [
    TransactionModel(transactionId: 't4', userId: 'u1', amount: 50.0, type: TransactionType.deposit, status: TransactionStatus.completed, createdAt: DateTime.now(), description: "Deposit from Visa **** 4242"),
    TransactionModel(transactionId: 't1', userId: 'u1', amount: 55.0, type: TransactionType.rentalEarning, status: TransactionStatus.completed, createdAt: DateTime.now().subtract(const Duration(days: 1)), description: "Rent for 'DJI Mavic Pro'"),
    TransactionModel(transactionId: 't2', userId: 'u1', amount: -100.0, type: TransactionType.withdrawal, status: TransactionStatus.completed, createdAt: DateTime.now().subtract(const Duration(days: 3)), description: "Withdrawal to Bank Account"),
    TransactionModel(transactionId: 't3', userId: 'u1', amount: 30.50, type: TransactionType.rentalEarning, status: TransactionStatus.completed, createdAt: DateTime.now().subtract(const Duration(days: 5)), description: "Rent for 'GoPro Hero 10'"),
  ];
  // --- FIN DE DATOS DE EJEMPLO ---

  @override
  void initState() {
    super.initState();
    // Abrir el modal correspondiente después de que el frame se haya renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.openDepositSheet) {
        _showDepositSheet(context, paymentMethods);
      }
      if (widget.openWithdrawSheet) {
        _showWithdrawSheet(context, availableBalance, payoutMethods);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('My Wallet', style: AppTextStyles.sectionTitle), // Cambiado a "My Wallet"
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const EarningsSummaryCard(),
            const SizedBox(height: 24),
            EarningsStatsGrid(
              paid: 280.00,
              pending: 40.50,
              withdrawn: 150.00,
              available: availableBalance,
            ),
            const SizedBox(height: 24),
            // <<<--- NUEVO LAYOUT DE BOTONES ---<<<
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: 'Deposit Funds',
                    icon: Icons.add_card,
                    onPressed: () => _showDepositSheet(context, paymentMethods),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: 'Withdraw Funds',
                    icon: Icons.north_east,
                    onPressed: () => _showWithdrawSheet(context, availableBalance, payoutMethods),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            RecentTransactionsList(transactions: recentTransactions),
          ],
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

  void _showWithdrawSheet(BuildContext context, double availableBalance, List<PayoutDestinationModel> methods) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WithdrawFundsSheet(
        availableBalance: availableBalance,
        payoutMethods: methods,
      ),
    );
  }

  // <<<--- NUEVA FUNCIÓN PARA MOSTRAR EL MODAL DE DEPÓSITO ---<<<
  void _showDepositSheet(BuildContext context, List<PaymentMethodModel> methods) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DepositFundsSheet(paymentMethods: methods),
    );
  }
}