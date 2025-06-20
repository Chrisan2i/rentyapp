// ARCHIVO: lib/features/earnings/widgets/deposit_funds_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart';
import 'package:rentyapp/core/controllers/wallet_controller.dart';
import 'package:rentyapp/features/earnings/add_payment_method_view.dart';

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
    // Añadimos el listener para que el botón se actualice al escribir
    _amountController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _amountController.removeListener(() {});
    _amountController.dispose();
    super.dispose();
  }

  Widget _getCardIcon(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return const Icon(Icons.credit_card, color: AppColors.primary);
      case 'mastercard':
        return const Icon(Icons.credit_card_sharp, color: AppColors.primary);
      default:
        return const Icon(Icons.credit_card, color: AppColors.primary);
    }
  }

  void _onAddNewCard() {
    Navigator.of(context).pop();

    Navigator.of(context).push(
      MaterialPageRoute(
        // Ya no se necesita ChangeNotifierProvider.value aquí porque el
        // WalletController se provee globalmente.
        builder: (_) => const AddPaymentMethodView(),
      ),
    );
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

              Row(
                children: _quickAmounts.map((amount) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: OutlinedButton(
                      onPressed: () { _amountController.text = amount.toStringAsFixed(2); },
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

              const Text('Select Payment Method', style: AppTextStyles.inputLabel),
              const SizedBox(height: 12),

              if (widget.paymentMethods.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Text("No payment methods found.", style: AppTextStyles.subtitle),
                  ),
                )
              else
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

              TextButton.icon(
                onPressed: _onAddNewCard,
                icon: const Icon(Icons.add, color: AppColors.primary),
                label: const Text('Add New Card', style: AppTextStyles.bannerAction),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _amountController.text.isEmpty || _selectedMethodId == null ? null : () { /* TODO: Lógica de depósito */ },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.primary.withAlpha(128),
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

  Widget _buildPaymentMethodTile(PaymentMethodModel method) {
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
                backgroundColor: AppColors.primary.withAlpha(26),
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