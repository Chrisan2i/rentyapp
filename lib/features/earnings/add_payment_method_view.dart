// lib/features/earnings/add_payment_method_view.dart (o donde lo tengas)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/core/utils/card_input_formatters.dart';
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

  Future<void> _onSaveCard() async {
    if (!_formKey.currentState!.validate()) {
      return; // Si el formulario no es válido, no hacemos nada.
    }

    final controller = context.read<WalletController>();
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final success = await controller.addPaymentMethod(
      cardNumber: _cardNumberController.text.replaceAll(' ', ''),
      expiryDate: _expiryDateController.text,
      cvv: _cvvController.text,
      cardHolderName: _cardHolderNameController.text,
    );

    if (success) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('¡Método de pago añadido con éxito!'),
          backgroundColor: Colors.green,
        ),
      );
      navigator.pop();
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(controller.error ?? 'Ocurrió un error desconocido.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos 'watch' para que los botones se actualicen cuando cambie el estado de carga.
    final controller = context.watch<WalletController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Añadir Nueva Tarjeta'),
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
                label: 'Número de Tarjeta',
                hint: '0000 0000 0000 0000',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberInputFormatter(),
                ],
                validator: (value) => value!.length < 19 ? 'Introduce un número de tarjeta válido' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _expiryDateController,
                      label: 'Fecha de Vencimiento',
                      hint: 'MM/AA',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        CardMonthInputFormatter(),
                      ],
                      validator: (value) => value!.length < 5 ? 'Introduce una fecha válida' : null,
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
                      validator: (value) => value!.length < 3 ? 'Introduce un CVV válido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _cardHolderNameController,
                label: 'Nombre del Titular',
                hint: 'John Doe',
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                validator: (value) => value!.isEmpty ? 'Introduce el nombre del titular' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  // --- SOLUCIÓN: Usar 'isAddingPaymentMethod' ---
                  onPressed: controller.isAddingPaymentMethod ? null : _onSaveCard,
                  icon: controller.isAddingPaymentMethod
                      ? Container()
                      : const Icon(Icons.security, size: 20),
                  label: controller.isAddingPaymentMethod
                      ? const SizedBox(
                    width: 24, height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('Guardar Tarjeta'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    disabledBackgroundColor: AppColors.primary.withAlpha(128),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tu método _buildTextField está perfecto, no necesita cambios
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
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.white.withAlpha(77)),
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