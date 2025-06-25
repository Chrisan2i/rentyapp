// lib/features/rentals/views/widgets/payment_method_selector_sheet.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart';
import 'package:rentyapp/core/controllers/wallet_controller.dart';
import 'package:rentyapp/features/earnings/add_payment_method_view.dart';

class PaymentMethodSelectorSheet extends StatelessWidget {
  final String currentSelectedMethodId;

  const PaymentMethodSelectorSheet({
    super.key,
    required this.currentSelectedMethodId,
  });

  @override
  Widget build(BuildContext context) {
    final walletController = context.watch<WalletController>();
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  // ✨ MEJORA: Texto en español.
                  'Selecciona un Método de Pago',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: walletController.paymentMethods.length,
                  separatorBuilder: (_, __) => const Divider(
                      color: AppColors.white10, height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (context, index) {
                    final method = walletController.paymentMethods[index];
                    final isSelected = method.paymentMethodId == currentSelectedMethodId;
                    return ListTile(
                      onTap: () => Navigator.of(context).pop(method),
                      leading: Icon(_getCardIcon(method.providerDetails['brand']), color: Colors.white),
                      title: Text(method.alias, style: const TextStyle(color: Colors.white)),
                      subtitle: method.isDefault
                      // ✨ MEJORA: Texto en español y estilo consistente.
                          ? Text('Predeterminado',
                          style: TextStyle(color: Colors.grey.shade400))
                          : null,
                      trailing: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? AppColors.primary : Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              const Divider(color: AppColors.white10, height: 1),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddPaymentMethodView()),
                  );
                },
                leading: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                title: const Text(
                  // ✨ MEJORA: Texto en español.
                  'Añadir nueva tarjeta',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              // ✨ MEJORA: Padding seguro para la parte inferior.
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }

  IconData _getCardIcon(String? brand) {
    // ✨ MEJORA: Puedes usar un paquete como `font_awesome_flutter` para iconos de marcas específicos.
    switch (brand?.toLowerCase()) {
      case 'visa':
      // return FontAwesomeIcons.ccVisa;
        return Icons.credit_card;
      case 'mastercard':
      // return FontAwesomeIcons.ccMastercard;
        return Icons.credit_card;
      case 'amex':
      // return FontAwesomeIcons.ccAmex;
        return Icons.credit_card;
      default:
        return Icons.credit_card_outlined;
    }
  }
}