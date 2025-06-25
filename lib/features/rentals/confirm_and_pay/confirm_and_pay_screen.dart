// lib/features/rentals/views/confirm_and_pay_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/rentals/models/contract_model.dart';
import 'package:rentyapp/features/rentals/services/rental_services.dart';
import 'package:rentyapp/core/controllers/confirm_pay_controller.dart';
import 'package:rentyapp/features/earnings/add_payment_method_view.dart';
import 'widgets/product_info_card.dart';
import 'widgets/rental_details_card.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/rental_terms_card.dart';
import 'widgets/security_info_box.dart';
import 'widgets/payment_bottom_bar.dart';
import 'widgets/payment_method_selector_sheet.dart';

class ConfirmAndPayScreen extends StatelessWidget {
  final RentalModel rental;
  final PaymentMethodModel defaultPaymentMethod;

  const ConfirmAndPayScreen({
    super.key,
    required this.rental,
    required this.defaultPaymentMethod,
  });

  void _showPaymentMethodSelector(BuildContext context) async {
    final controller = context.read<ConfirmAndPayController>();
    final navigator = Navigator.of(context);

    final selectedMethod = await showModalBottomSheet<PaymentMethodModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentMethodSelectorSheet(
        currentSelectedMethodId: controller.selectedPaymentMethod?.paymentMethodId ?? '',
      ),
    );
    if (selectedMethod != null) {
      controller.updateSelectedPaymentMethod(selectedMethod);
    }
  }

  void _navigateToAddPaymentMethod(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddPaymentMethodView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConfirmAndPayController(
        rentalService: context.read<RentalService>(),
        rental: rental,
        initialPaymentMethod: defaultPaymentMethod,
      ),
      child: Consumer<ConfirmAndPayController>(
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: const Color(0xFF121212),
            appBar: AppBar(
              backgroundColor: const Color(0xFF121212),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('Confirmar y Pagar', style: TextStyle(color: Colors.white)),
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
                  PaymentMethodCard(
                    paymentMethod: controller.selectedPaymentMethod,
                    onChangePressed: () => _showPaymentMethodSelector(context),
                    onAddPressed: () => _navigateToAddPaymentMethod(context),
                  ),
                  const SizedBox(height: 16),
                  RentalTermsCard(
                    termsAgreed: controller.termsAgreed,
                    onTermsChanged: (value) => controller.setTermsAgreed(value ?? false),
                  ),
                  const SizedBox(height: 24),
                  const SecurityInfoBox(),
                  const SizedBox(height: 120), // Space for bottom bar
                ],
              ),
            ),
            bottomNavigationBar: PaymentBottomBar(
              totalAmount: rental.financials['total'] ?? 0.0,
              isLoading: controller.isLoading,
              isTermsAgreed: controller.termsAgreed,
              onPayPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                final success = await controller.confirmAndPay();

                if (success) {
                  final contractId = controller.transactionId;
                  final contract = ContractModel(
                    contractId: contractId,
                    landlordId: rental.ownerInfo['userId'] as String,
                    tenantId:  rental.renterInfo['userId'] as String,
                    productId: rental.productInfo['productId'] as String,
                    startAt:    rental.startDate,
                    endAt:      rental.endDate,
                    price:      rental.financials['total'] ?? 0.0,
                    deposit:    rental.financials['deposit'] ?? 0.0,
                    placeholders: {
                      'nombre_arrendador':    rental.ownerInfo['fullName'] as String,
                      'documento_arrendador': rental.ownerInfo['documentId'] as String? ?? 'N/A',
                      'nombre_arrendatario':  rental.renterInfo['fullName'] as String,
                      'documento_arrendatario': rental.renterInfo['documentId'] as String? ?? 'N/A',
                      'nombre_producto':      rental.productInfo['title'] as String,
                      'estado_producto':      "Usado",
                      'fecha_inicio':         DateFormat('yyyy-MM-dd HH:mm').format(rental.startDate),
                      'fecha_fin':            DateFormat('yyyy-MM-dd HH:mm').format(rental.endDate),
                      'precio':               (rental.financials['total'] ?? 0.0).toStringAsFixed(2),
                      'monto_garantia':       (rental.financials['deposit'] ?? 0.0).toStringAsFixed(2),
                      'fecha_hora_actual':    DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
                      'id_transaccion':       contractId,
                    },
                    templateVersion: 'v1',
                    signedAt:        null,
                    contractCode:    contractId,
                    pdfUrl:          null,
                    status:          'pending',
                    createdAt:       DateTime.now(),
                    updatedAt:       DateTime.now(),
                  );
                  await RentalService.createContract(rental.rentalId, contract);

                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('✅ Pago completado. Contrato generado.'), backgroundColor: Colors.green),
                  );
                  navigator.pop(true);
                } else {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Error al procesar el pago: ${controller.error}'), backgroundColor: Colors.red),
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
