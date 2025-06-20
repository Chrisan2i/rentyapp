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
    // Escuchamos al WalletController para obtener la lista de métodos de pago
    final walletController = context.watch<WalletController>();

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
              // "Handle" para indicar que se puede arrastrar
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Select a Payment Method',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: walletController.paymentMethods.length,
                  separatorBuilder: (_, __) => const Divider(color: AppColors.white10, height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (context, index) {
                    final method = walletController.paymentMethods[index];
                    final isSelected = method.paymentMethodId == currentSelectedMethodId;
                    return ListTile(
                      onTap: () {
                        // Al seleccionar, cerramos la hoja y devolvemos el método elegido
                        Navigator.of(context).pop(method);
                      },
                      leading: Icon(
                        _getCardIcon(method.providerDetails['brand']),
                        color: Colors.white,
                      ),
                      title: Text(method.alias, style: const TextStyle(color: Colors.white)),
                      subtitle: method.isDefault
                          ? Text('Default', style: TextStyle(color: Colors.grey.shade400))
                          : null,
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.primary)
                          : const Icon(Icons.circle_outlined, color: Colors.grey),
                    );
                  },
                ),
              ),
              const Divider(color: AppColors.white10, height: 1),
              // Botón para agregar nueva tarjeta
              ListTile(
                onTap: () {
                  // Navegamos a la vista de agregar tarjeta
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddPaymentMethodView()),
                  );
                },
                leading: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                title: const Text('Add a new card', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }

  IconData _getCardIcon(String? brand) {
    switch (brand?.toLowerCase()) {
      case 'visa':
        return Icons.credit_card; // Puedes usar paquetes como `font_awesome_flutter` para iconos de marcas
      case 'mastercard':
        return Icons.credit_card;
      case 'amex':
        return Icons.credit_card;
      default:
        return Icons.credit_card_outlined;
    }
  }
}