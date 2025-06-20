import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/controllers/controller.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart';
import 'package:rentyapp/features/auth/services/payment_service.dart';
import 'package:rentyapp/features/rentals/confirm_and_pay/confirm_and_pay_screen.dart';


import 'widgets/rental_card_widget.dart';
import 'widgets/rental_status_selector.dart';
import 'widgets/rental_tab_selector.dart';

class RentalView extends StatefulWidget {
  const RentalView({super.key});

  @override
  State<RentalView> createState() => _RentalViewState();
}

class _RentalViewState extends State<RentalView> {
  String _currentTab = 'renter'; // 'renter' o 'owner'
  bool _isOngoingSelected = true; // true para 'Ongoing', false para 'Past'
  bool _isProcessingPayment = false; // Estado para mostrar carga al presionar "Pay Now"

  // Instanciamos el servicio que vamos a necesitar.
  final PaymentService _paymentService = PaymentService();

  /// Filtra la lista de alquileres basándose en las pestañas seleccionadas.
  List<RentalModel> _filterRentals(
      List<RentalModel> allRentals, String userId) {
    return allRentals.where((rental) {
      final bool isUserRenter = rental.renterInfo['userId'] == userId;
      final bool isUserOwner = rental.ownerInfo['userId'] == userId;

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

  /// Maneja la lógica cuando el usuario presiona el botón "Pay Now" en una tarjeta.
  Future<void> _handlePayNowPressed(RentalModel rental) async {
    // Evita que el usuario haga múltiples clicks mientras se procesa.
    if (_isProcessingPayment) return;

    // Muestra un indicador de carga en toda la pantalla.
    setState(() => _isProcessingPayment = true);

    try {
      final controller = Provider.of<AppController>(context, listen: false);
      final userId = controller.currentUser?.userId;

      if (userId == null) {
        throw Exception("User not logged in. Please restart the app.");
      }

      // Llama al servicio para obtener el método de pago por defecto.
      final PaymentMethodModel? paymentMethod =
      await _paymentService.getDefaultPaymentMethod(userId);

      if (paymentMethod == null) {
        // Si no hay método de pago, informa al usuario.
        throw Exception(
            "No default payment method found. Please add one in your profile.");
      }

      // Antes de navegar, verifica si el widget sigue en pantalla.
      if (!mounted) return;

      // Navega a la pantalla de pago con toda la información necesaria.
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmAndPayScreen(
            rental: rental,
            defaultPaymentMethod: paymentMethod,
          ),
        ),
      );
    } catch (e) {
      // Si ocurre cualquier error, muéstralo en un SnackBar.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      // Ya sea que la operación fue exitosa o no, oculta el indicador de carga.
      if (mounted) {
        setState(() => _isProcessingPayment = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AppController>(context);

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
      // Usamos un Stack para poder mostrar el indicador de carga por encima de todo el cuerpo.
      body: Stack(
        children: [
          _buildBody(controller),
          if (_isProcessingPayment)
          // Widget de carga modal
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

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RentalTabSelector(
                  currentTab: _currentTab,
                  onTabSelected: (tabType) =>
                      setState(() => _currentTab = tabType),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RentalStatusSelector(
                  isOngoingSelected: _isOngoingSelected,
                  onStatusSelected: (isOngoing) =>
                      setState(() => _isOngoingSelected = isOngoing),
                ),
              ),
              const SizedBox(height: 20),
              if (filteredRentals.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Center(
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredRentals.length,
                  itemBuilder: (context, index) {
                    // --- ¡AQUÍ ESTÁ LA CONEXIÓN CLAVE! ---
                    // Pasamos nuestra función de lógica al callback de la tarjeta.
                    return RentalCardWidget(
                      rental: filteredRentals[index],
                      currentTab: _currentTab,
                      onPayNowPressed: _handlePayNowPressed, // <- Conectado
                    );
                  },
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 16),
                ),
              const SizedBox(height: 40),
            ],
          ),
        );
    }
  }
}