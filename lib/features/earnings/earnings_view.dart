// lib/features/earnings/earnings_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/core/controllers/wallet_controller.dart';
import 'package:rentyapp/features/earnings/widgets/deposit_funds_sheet.dart';
import 'package:rentyapp/features/earnings/widgets/earnings_stats_grid.dart';
import 'package:rentyapp/features/earnings/widgets/earnings_summary_card.dart';
import 'package:rentyapp/features/earnings/widgets/recent_transactions_list.dart';
import 'package:rentyapp/features/earnings/widgets/withdraw_funds_sheet.dart';

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
    // Se ejecuta después de que el primer frame se haya renderizado.
    // Esto asegura que el `context` esté disponible y listo para mostrar modales.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final controller = context.read<WalletController>();
        if (widget.openDepositSheet) {
          _showDepositSheet(context, controller);
        }
        if (widget.openWithdrawSheet) {
          _showWithdrawSheet(context, controller);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Usamos 'watch' para que la UI se reconstruya cuando el controller notifique cambios.
    final controller = context.watch<WalletController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Mi Billetera', style: AppTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchWalletData, // Llama directamente a la función para recargar.
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        // Usamos un Builder para manejar los diferentes estados del controlador.
        child: _buildBody(context, controller),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WalletController controller) {
    // Manejo de estado basado en el enum 'state' del controlador.
    switch (controller.state) {
      case WalletState.loading:
      case WalletState.initial:
      // Muestra un indicador de carga mientras los datos se obtienen por primera vez.
        return const Center(child: CircularProgressIndicator(color: AppColors.primary));

      case WalletState.error:
      // Muestra un mensaje de error si la carga falla.
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  controller.error ?? 'Ocurrió un error desconocido.',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  onPressed: controller.fetchWalletData,
                  label: const Text('Intentar de nuevo'),
                )
              ],
            ),
          ),
        );

      case WalletState.loaded:
      // El contenido principal se muestra solo cuando los datos están cargados.
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Permite el "pull-to-refresh".
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- CORRECCIÓN APLICADA AQUÍ ---
              // Ahora le pasamos el `availableBalance` al widget.
              EarningsSummaryCard(
                availableBalance: controller.walletStats['available'] ?? 0.0,
              ),
              // --- FIN DE LA CORRECCIÓN ---
              const SizedBox(height: 24),
              EarningsStatsGrid(
                paid: controller.walletStats['paid'] ?? 0,
                pending: controller.walletStats['pending'] ?? 0,
                withdrawn: controller.walletStats['withdrawn'] ?? 0,
                available: controller.walletStats['available'] ?? 0,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildActionButton(context, label: 'Depositar', icon: Icons.add_card, onPressed: () => _showDepositSheet(context, controller))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildActionButton(context, label: 'Retirar', icon: Icons.north_east, onPressed: () => _showWithdrawSheet(context, controller))),
                ],
              ),
              const SizedBox(height: 32),
              // Muestra un mensaje si no hay transacciones, o la lista si las hay.
              if (controller.transactions.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.0),
                  child: Center(
                    child: Text("Aún no tienes transacciones.", style: AppTextStyles.subtitle),
                  ),
                )
              else
                RecentTransactionsList(transactions: controller.transactions),
            ],
          ),
        );
    }
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WithdrawFundsSheet(
        // Accedemos a los datos directamente, ya no es un Future.
        availableBalance: controller.walletStats['available'] ?? 0.0,
        payoutMethods: controller.payoutMethods,
      ),
    );
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