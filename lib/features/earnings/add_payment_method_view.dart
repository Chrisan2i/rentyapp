// lib/features/earnings/views/add_payment_method_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

// Importa los formatters para los campos de la tarjeta
import 'package:rentyapp/core/utils/card_input_formatters.dart';
// <<<--- CORRECCIÓN: El import estaba mal escrito. Ahora apunta al controlador correcto. ---<<<
import 'package:rentyapp/core/controllers/wallet_controller.dart';

class AddPaymentMethodView extends StatefulWidget {
  const AddPaymentMethodView({super.key});

  @override
  State<AddPaymentMethodView> createState() => _AddPaymentMethodViewState();
}

class _AddPaymentMethodViewState extends State<AddPaymentMethodView> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderNameController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderNameController.dispose();
    super.dispose();
  }

  void _onSaveCard() async { // Marcar como async
    if (_formKey.currentState!.validate()) {
      final controller = context.read<WalletController>();
      try {
        await controller.addPaymentMethod(
          cardNumber: _cardNumberController.text.replaceAll(' ', ''),
          expiryDate: _expiryDateController.text,
          cvv: _cvvController.text,
          cardHolderName: _cardHolderNameController.text,
        );

        // CORRECCIÓN: Si el método anterior no lanza un error, fue exitoso.
        // Ahora la UI muestra la notificación y navega.
        // Se comprueba si el widget sigue montado antes de usar el context.
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment method added successfully!'),
            backgroundColor: Colors.green, // Usar un color estándar o de tu tema
          ),
        );
        Navigator.of(context).pop();

      } catch (e) {
        // Si el controlador lanzó un error, lo atrapamos aquí.
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.error ?? 'An unknown error occurred.'),
            backgroundColor: Colors.red, // Usar un color estándar o de tu tema
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WalletController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add New Card'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _cardNumberController,
                label: 'Card Number',
                hint: '0000 0000 0000 0000',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberInputFormatter(),
                ],
                validator: (value) => value!.length < 19 ? 'Enter a valid card number' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _expiryDateController,
                      label: 'Expiry Date',
                      hint: 'MM/YY',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        CardMonthInputFormatter(),
                      ],
                      validator: (value) => value!.length < 5 ? 'Enter a valid date' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _cvvController,
                      label: 'CVV',
                      hint: '123',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: (value) => value!.length < 3 ? 'Enter a valid CVV' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _cardHolderNameController,
                label: 'Card Holder Name',
                hint: 'John Doe',
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                validator: (value) => value!.isEmpty ? 'Enter card holder name' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoading ? null : _onSaveCard,
                  icon: controller.isLoading
                      ? Container()
                      : const Icon(Icons.security, size: 20),
                  label: controller.isLoading
                      ? const SizedBox(
                    width: 24, height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('Save Card Securely'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    // <<<--- CORRECCIÓN: Se usa .withAlpha() en lugar del obsoleto .withOpacity(). ---<<<
                    disabledBackgroundColor: AppColors.primary.withAlpha(128), // 255 * 0.5 = 127.5
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputLabel),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            // <<<--- CORRECCIÓN: Se usa .withAlpha() en lugar del obsoleto .withOpacity(). ---<<<
            hintStyle: TextStyle(color: AppColors.white.withAlpha(77)), // 255 * 0.3 = 76.5
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.white10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}