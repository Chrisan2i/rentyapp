import 'package:flutter/material.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart';
import 'package:rentyapp/features/rentals/services/rental_services.dart';

// Importa todos los nuevos widgets que creamos
import 'widgets/product_info_card.dart';
import 'widgets/rental_details_card.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/rental_terms_card.dart';
import 'widgets/security_info_box.dart';
import 'widgets/payment_bottom_bar.dart';


class ConfirmAndPayScreen extends StatefulWidget {
  final RentalModel rental;
  final PaymentMethodModel defaultPaymentMethod;

  const ConfirmAndPayScreen({
    super.key,
    required this.rental,
    required this.defaultPaymentMethod,
  });

  @override
  State<ConfirmAndPayScreen> createState() => _ConfirmAndPayScreenState();
}

class _ConfirmAndPayScreenState extends State<ConfirmAndPayScreen> {
  bool _termsAgreed = false;
  bool _isLoading = false;
  final RentalService _rentalService = RentalService();

  Future<void> _processPayment() async {
    // La lógica de pago no necesita estar en el widget de la UI.
    // Vive aquí, en el 'controlador' de la pantalla.
    if (!_termsAgreed) return;

    setState(() => _isLoading = true);

    try {
      await _rentalService.confirmAndPayRental(widget.rental.rentalId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Pago completado. Esperando entrega.'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pop(true); // Indica éxito

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Confirm & Pay Rental', style: TextStyle(color: Colors.white)),
        actions: [IconButton(icon: const Icon(Icons.support_agent_outlined, color: Colors.white), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ¡Mira qué limpio queda el árbol de widgets!
            ProductInfoCard(rental: widget.rental),
            const SizedBox(height: 16),
            RentalDetailsCard(rental: widget.rental),
            const SizedBox(height: 16),
            PaymentMethodCard(paymentMethod: widget.defaultPaymentMethod),
            const SizedBox(height: 16),
            RentalTermsCard(
              termsAgreed: _termsAgreed,
              onTermsChanged: (value) {
                setState(() {
                  _termsAgreed = value ?? false;
                });
              },
            ),
            const SizedBox(height: 24),
            const SecurityInfoBox(),
            const SizedBox(height: 40), // Espacio para que el bottom bar no tape nada
          ],
        ),
      ),
      bottomNavigationBar: PaymentBottomBar(
        totalAmount: widget.rental.financials['total'] ?? 0.0,
        isLoading: _isLoading,
        isTermsAgreed: _termsAgreed,
        onPayPressed: _processPayment,
      ),
    );
  }
}