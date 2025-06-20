// lib/features/rentals/views/confirm_and_pay_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/rentals/services/rental_services.dart';

import 'package:rentyapp/core/controllers/confirm_pay_controller.dart';
import 'widgets/product_info_card.dart';
import 'widgets/rental_details_card.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/rental_terms_card.dart';
import 'widgets/security_info_box.dart';
import 'widgets/payment_bottom_bar.dart';
// Importa la nueva hoja modal
import 'widgets/payment_method_selector_sheet.dart';

class ConfirmAndPayScreen extends StatelessWidget {
  final RentalModel rental;
  final PaymentMethodModel defaultPaymentMethod;

  const ConfirmAndPayScreen({
    super.key,
    required this.rental,
    required this.defaultPaymentMethod,
  });

  // --- NUEVO MÉTODO PARA MOSTRAR LA HOJA MODAL ---
  void _showPaymentMethodSelector(BuildContext context) async {
    final controller = context.read<ConfirmAndPayController>();

    // Mostramos la hoja modal y esperamos a que nos devuelva un resultado
    final selectedMethod = await showModalBottomSheet<PaymentMethodModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentMethodSelectorSheet(
        currentSelectedMethodId: controller.selectedPaymentMethod.paymentMethodId,
      ),
    );

    // Si el usuario seleccionó un nuevo método, lo actualizamos en el controlador
    if (selectedMethod != null) {
      controller.updateSelectedPaymentMethod(selectedMethod);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConfirmAndPayController(
        rentalService: context.read<RentalService>(),
        rental: rental,
        initialPaymentMethod: defaultPaymentMethod, // Pasamos el método inicial
      ),
      child: Consumer<ConfirmAndPayController>(
        builder: (context, controller, child) {
          return Scaffold(
            // ... (AppBar y Scaffold body no cambian)
            backgroundColor: const Color(0xFF121212),
            appBar: AppBar(
              backgroundColor: const Color(0xFF121212),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('Confirm & Pay Rental', style: TextStyle(color: Colors.white)),
              actions: [
                IconButton(icon: const Icon(Icons.support_agent_outlined, color: Colors.white), onPressed: () {})
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProductInfoCard(rental: rental),
                  const SizedBox(height: 16),
                  RentalDetailsCard(rental: rental),
                  const SizedBox(height: 16),
                  // El widget ahora obtiene el método de pago del controlador
                  // y tiene una acción para el botón "Change"
                  PaymentMethodCard(
                    paymentMethod: controller.selectedPaymentMethod,
                    onChangePressed: () => _showPaymentMethodSelector(context),
                  ),
                  const SizedBox(height: 16),
                  RentalTermsCard(
                    termsAgreed: controller.termsAgreed,
                    onTermsChanged: (value) {
                      controller.setTermsAgreed(value ?? false);
                    },
                  ),
                  const SizedBox(height: 24),
                  const SecurityInfoBox(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
            bottomNavigationBar: PaymentBottomBar(
              //... (El bottom bar no necesita cambios)
              totalAmount: rental.financials['total'] ?? 0.0,
              isLoading: controller.isLoading,
              isTermsAgreed: controller.termsAgreed,
              onPayPressed: () async {
                final success = await controller.confirmAndPay();

                if (!context.mounted) return;

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Pago completado. Esperando entrega.'), backgroundColor: Colors.green),
                  );
                  Navigator.of(context).pop(true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${controller.error}'), backgroundColor: Colors.red),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}