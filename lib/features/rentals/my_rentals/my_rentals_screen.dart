// lib/features/rentals/rental_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/controllers/controller.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/earnings/add_payment_method_view.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart';
import 'package:rentyapp/features/rentals/confirm_and_pay/confirm_and_pay_screen.dart';
import 'package:rentyapp/core/controllers/wallet_controller.dart';
import 'widgets/rental_card_widget.dart';
import 'widgets/rental_status_selector.dart';
import 'widgets/rental_tab_selector.dart';

class RentalView extends StatefulWidget {
  const RentalView({super.key});

  @override
  State<RentalView> createState() => _RentalViewState();
}

class _RentalViewState extends State<RentalView> {
  String _currentTab = 'renter';
  bool _isOngoingSelected = true;
  bool _isProcessingPayment = false;

  List<RentalModel> _filterRentals(List<RentalModel> allRentals, String userId) {
    // ... (La lógica de filtrado no necesita cambios, está bien)
    return allRentals.where((rental) {
      final isUserRenter = rental.renterInfo['userId'] == userId;
      final isUserOwner = rental.ownerInfo['userId'] == userId;

      if (_currentTab == 'renter' && !isUserRenter) return false;
      if (_currentTab == 'owner' && !isUserOwner) return false;

      final isOngoingStatus = rental.status == RentalStatus.ongoing ||
          rental.status == RentalStatus.awaiting_delivery ||
          rental.status == RentalStatus.awaiting_payment;

      if (_isOngoingSelected) {
        return isOngoingStatus;
      } else {
        return !isOngoingStatus;
      }
    }).toList();
  }

  Future<void> _handlePayNowPressed(RentalModel rental) async {
    if (_isProcessingPayment) return;
    setState(() => _isProcessingPayment = true);

    final walletController = context.read<WalletController>();
    final appController = context.read<AppController>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      PaymentMethodModel? paymentMethod;
      if (walletController.paymentMethods.isNotEmpty) {
        try {
          paymentMethod = walletController.paymentMethods.firstWhere((m) => m.isDefault);
        } catch (e) {
          paymentMethod = walletController.paymentMethods.first;
        }
      }

      if (paymentMethod != null) {
        final result = await navigator.push<bool>(
          MaterialPageRoute(
            builder: (context) => ConfirmAndPayScreen(
              rental: rental,
              defaultPaymentMethod: paymentMethod!,
            ),
          ),
        );
        if (result == true) {
          appController.fetchUserRentals();
        }
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            // ✨ MEJORA: Texto en español.
            content: Text('Por favor, añade un método de pago para continuar.'),
            backgroundColor: AppColors.warning,
            duration: Duration(seconds: 3),
          ),
        );
        await navigator.push(
          MaterialPageRoute(builder: (_) => const AddPaymentMethodView()),
        );
        await walletController.fetchWalletData();
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            // ✨ MEJORA: Texto en español.
            content: Text('Ocurrió un error inesperado: ${e.toString()}'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessingPayment = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          // ✨ MEJORA: Texto en español.
          'Mis Alquileres',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildBody(controller),
          if (_isProcessingPayment)
          // ✨ MEJORA: Overlay de carga más profesional.
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(AppController controller) {
    switch (controller.rentalsState) {
      case ViewState.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      case ViewState.error:
      // ✨ MEJORA: Se usa el nuevo widget de estado vacío para errores.
        return const _EmptyState(
          icon: Icons.error_outline,
          message: "Error al cargar los alquileres.",
          color: AppColors.danger,
        );
      case ViewState.idle:
        if (controller.currentUser == null) {
          // ✨ MEJORA: Se usa el nuevo widget de estado vacío.
          return const _EmptyState(
            icon: Icons.login,
            message: "Inicia sesión para ver tus alquileres.",
          );
        }
        final filteredRentals = _filterRentals(controller.rentals, controller.currentUser!.userId);

        return RefreshIndicator(
          onRefresh: () async => controller.fetchUserRentals(),
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RentalTabSelector(
                  currentTab: _currentTab,
                  onTabSelected: (tabType) => setState(() => _currentTab = tabType),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RentalStatusSelector(
                  isOngoingSelected: _isOngoingSelected,
                  onStatusSelected: (isOngoing) => setState(() => _isOngoingSelected = isOngoing),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: filteredRentals.isEmpty
                    ? const _EmptyState(
                  icon: Icons.inventory_2_outlined,
                  message: "No tienes alquileres en esta categoría.",
                )
                    : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                  itemCount: filteredRentals.length,
                  itemBuilder: (context, index) {
                    return RentalCardWidget(
                      rental: filteredRentals[index],
                      currentTab: _currentTab,
                      onPayNowPressed: _handlePayNowPressed,
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                ),
              ),
            ],
          ),
        );
    }
  }
}

// ✨ MEJORA: Widget reutilizable para mostrar estados vacíos o de error.
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color? color;

  const _EmptyState({
    required this.icon,
    required this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: color ?? Colors.grey.shade600),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: color ?? Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}