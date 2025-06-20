// ARCHIVO: lib/features/earnings/widgets/withdraw_funds_sheet.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/payout_destination_model.dart';

class WithdrawFundsSheet extends StatefulWidget {
  final double availableBalance;
  final List<PayoutDestinationModel> payoutMethods;

  const WithdrawFundsSheet({
    super.key,
    required this.availableBalance,
    required this.payoutMethods,
  });

  @override
  State<WithdrawFundsSheet> createState() => _WithdrawFundsSheetState();
}

class _WithdrawFundsSheetState extends State<WithdrawFundsSheet> {
  String? _selectedMethodId;

  @override
  void initState() {
    super.initState();
    // Pre-seleccionar el método por defecto si existe
    try {
      _selectedMethodId = widget.payoutMethods.firstWhere((m) => m.isDefault).destinationId;
    } catch (e) {
      if (widget.payoutMethods.isNotEmpty) {
        _selectedMethodId = widget.payoutMethods.first.destinationId;
      }
    }
  }

  // Helper para obtener el icono correcto
  IconData _getIconForType(String type) {
    switch (type) {
      case 've_bank_account': return Icons.account_balance;
      case 'paypal': return Icons.paypal; // Necesitarías un icono de Paypal, usamos uno de stock
      case 'zelle': return Icons.send_to_mobile;
      default: return Icons.credit_card;
    }
  }

  // Helper para obtener el subtitulo
  String _getSubtitleForMethod(PayoutDestinationModel method) {
    if (method.type == 've_bank_account') {
      return '**** ${method.destinationDetails['last4'] ?? ''}';
    }
    return method.destinationDetails['email'] ?? 'No details';
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(decimalDigits: 2, name: '\$');

    return Padding(
      // Evita que el teclado cubra la UI
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E), // Un color ligeramente más claro para el sheet
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Encabezado ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Withdraw Funds', style: AppTextStyles.sectionTitle),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppColors.white70),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              ],
            ),
            const SizedBox(height: 24),

            // --- Saldo Disponible ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available Balance', style: AppTextStyles.subtitle),
                  const SizedBox(height: 4),
                  Text(
                    formatCurrency.format(widget.availableBalance),
                    style: AppTextStyles.headlinePrimary.copyWith(fontSize: 28),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- Selección de Método ---
            const Text('Select Payment Method', style: AppTextStyles.inputLabel),
            const SizedBox(height: 12),
            ListView.separated(
              itemCount: widget.payoutMethods.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final method = widget.payoutMethods[index];
                final bool isSelected = _selectedMethodId == method.destinationId;
                return Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => setState(() => _selectedMethodId = method.destinationId),
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
                            child: Icon(_getIconForType(method.type), color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(method.alias, style: AppTextStyles.inputLabel.copyWith(color: AppColors.white)),
                                Text(_getSubtitleForMethod(method), style: AppTextStyles.subtitle),
                              ],
                            ),
                          ),
                          Radio<String>(
                            value: method.destinationId,
                            groupValue: _selectedMethodId,
                            onChanged: (value) => setState(() => _selectedMethodId = value),
                            activeColor: AppColors.primary,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // --- Botón de Acción ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedMethodId == null ? null : () { /* TODO: Lógica de retiro */ },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Withdraw ${formatCurrency.format(widget.availableBalance)}',
                  style: AppTextStyles.button.copyWith(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}