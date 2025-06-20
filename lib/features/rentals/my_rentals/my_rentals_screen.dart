// lib/features/rentals/rental_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/controllers/controller.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/earnings/add_payment_method_view.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart';
import 'package:rentyapp/features/auth/services/payment_service.dart';
import 'package:rentyapp/features/rentals/confirm_and_pay/confirm_and_pay_screen.dart';
import 'package:rentyapp/core/controllers/wallet_controller.dart'; // Importa el WalletController

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

  // Ya no necesitas instanciar PaymentService aquí, usaremos el WalletController
  // final PaymentService _paymentService = PaymentService();

  List<RentalModel> _filterRentals(List<RentalModel> allRentals, String userId) {
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

  /// Maneja la lógica cuando el usuario presiona "Pay Now".
  /// --- ESTA FUNCIÓN ESTÁ COMPLETAMENTE RECONSTRUIDA ---
  Future<void> _handlePayNowPressed(RentalModel rental) async {
    if (_isProcessingPayment) return;
    setState(() => _isProcessingPayment = true);

    try {
      // Usamos el WalletController que ya está disponible globalmente.
      final walletController = context.read<WalletController>();

      // La lógica para obtener el método de pago por defecto ahora es más simple
      // y está dentro del controlador (si lo necesitaras). Por ahora, lo hacemos aquí.
      PaymentMethodModel? defaultMethod;
      try {
        defaultMethod = walletController.paymentMethods.firstWhere((m) => m.isDefault);
      } catch (e) {
        defaultMethod = null; // No se encontró ningún método por defecto.
      }

      // Si el widget ya no está en pantalla, no hacemos nada.
      if (!mounted) return;

      if (defaultMethod != null) {
        // CASO 1: Hay un método de pago. Navegamos a la pantalla de confirmación.
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ConfirmAndPayScreen(
              rental: rental,
              defaultPaymentMethod: defaultMethod!,
            ),
          ),
        );
      } else {
        // CASO 2: No hay método de pago. Guiamos al usuario.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add a payment method to continue.'),
            backgroundColor: AppColors.warning, // Un color más amigable que el rojo
          ),
        );
        // Navegamos a la pantalla para añadir un método de pago.
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AddPaymentMethodView(),
          ),
        );
      }
    } catch (e) {
      // Capturamos cualquier otro error inesperado.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: ${e.toString()}'),
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
          'My Rentals',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildBody(controller),
          if (_isProcessingPayment)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
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
        return const Center(
          child: Text(
            "Error loading rentals.",
            style: TextStyle(color: AppColors.danger),
          ),
        );
      case ViewState.idle:
        if (controller.currentUser == null) {
          return const Center(
            child: Text(
              "Please log in to see your rentals.",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }
        final filteredRentals = _filterRentals(
          controller.rentals,
          controller.currentUser!.userId,
        );
        return RefreshIndicator(
          onRefresh: () async => controller.fetchUserRentals(),
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                if (filteredRentals.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                    child: const Center(
                      child: Text(
                        "No rentals found in this category.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
              ],
            ),
          ),
        );
    }
  }
}