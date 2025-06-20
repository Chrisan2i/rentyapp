// ARCHIVO: lib/features/earnings/widgets/deposit_funds_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart';

class DepositFundsSheet extends StatefulWidget {
  final List<PaymentMethodModel> paymentMethods;
  const DepositFundsSheet({super.key, required this.paymentMethods});

  @override
  State<DepositFundsSheet> createState() => _DepositFundsSheetState();
}

class _DepositFundsSheetState extends State<DepositFundsSheet> {
  String? _selectedMethodId;
  final TextEditingController _amountController = TextEditingController();
  final List<double> _quickAmounts = [20.0, 50.0, 100.0];

  @override
  void initState() {
    super.initState();
    try {
      _selectedMethodId = widget.paymentMethods.firstWhere((m) => m.isDefault).paymentMethodId;
    } catch (e) {
      if (widget.paymentMethods.isNotEmpty) {
        _selectedMethodId = widget.paymentMethods.first.paymentMethodId;
      }
    }
  }

  // Helper para obtener el icono de la tarjeta
  Widget _getCardIcon(String brand) {
    // En una app real, usarías imágenes SVG de las marcas
    switch (brand.toLowerCase()) {
      case 'visa':
        return const Icon(Icons.credit_card, color: AppColors.primary);
      case 'mastercard':
        return const Icon(Icons.credit_card_sharp, color: AppColors.primary);
      default:
        return const Icon(Icons.credit_card, color: AppColors.primary);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Deposit Funds', style: AppTextStyles.sectionTitle),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: AppColors.white70),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                ],
              ),
              const SizedBox(height: 24),

              // Campo de Monto
              const Text('Amount', style: AppTextStyles.inputLabel),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                style: AppTextStyles.headlinePrimary,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  prefixStyle: AppTextStyles.headlinePrimary.copyWith(color: AppColors.white70),
                  hintText: '0.00',
                  hintStyle: AppTextStyles.headlinePrimary.copyWith(color: AppColors.white30),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Montos Rápidos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _quickAmounts.map((amount) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: OutlinedButton(
                      onPressed: () {
                        _amountController.text = amount.toStringAsFixed(2);
                        setState(() {});
                      },
                      child: Text('\$${amount.toInt()}'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white70,
                        side: const BorderSide(color: AppColors.white10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 24),

              // Selección de Método de Pago
              const Text('Select Payment Method', style: AppTextStyles.inputLabel),
              const SizedBox(height: 12),
              ListView.separated(
                itemCount: widget.paymentMethods.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final method = widget.paymentMethods[index];
                  return _buildPaymentMethodTile(method);
                },
              ),
              const SizedBox(height: 12),
              // Botón para añadir nuevo método
              TextButton.icon(
                onPressed: (){ /* TODO: Navegar a la pantalla de añadir tarjeta */ },
                icon: const Icon(Icons.add, color: AppColors.primary),
                label: const Text('Add New Card', style: AppTextStyles.bannerAction),
              ),
              const SizedBox(height: 24),

              // Botón de Acción
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _amountController.text.isEmpty || _selectedMethodId == null ? null : () { /* TODO: Lógica de depósito */ },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _amountController.text.isEmpty ? 'Deposit' : 'Deposit \$${_amountController.text}',
                    style: AppTextStyles.button.copyWith(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile(PaymentMethodModel method){
    final bool isSelected = _selectedMethodId == method.paymentMethodId;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => setState(() => _selectedMethodId = method.paymentMethodId),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.white10,
                width: isSelected ? 1.5 : 1,
              )
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: _getCardIcon(method.providerDetails['brand'] ?? ''),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(method.alias, style: AppTextStyles.inputLabel.copyWith(color: AppColors.white)),
                    Text(
                        '**** **** **** ${method.providerDetails['last4'] ?? ''}',
                        style: AppTextStyles.subtitle
                    ),
                  ],
                ),
              ),
              Radio<String>(
                value: method.paymentMethodId,
                groupValue: _selectedMethodId,
                onChanged: (value) => setState(() => _selectedMethodId = value),
                activeColor: AppColors.primary,
              )
            ],
          ),
        ),
      ),
    );
  }
}