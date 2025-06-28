// lib/features/add_product/widgets/pricing_availability_step.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PricingAvailabilityStep extends StatelessWidget {
  final Map<String, bool> selectedRates;
  final Map<String, TextEditingController> rateControllers;
  final TextEditingController securityDepositController;
  final bool instantBooking;
  final VoidCallback onToggleInstantBooking;
  final Function(String) onRateTypeToggle;

  const PricingAvailabilityStep({
    super.key,
    required this.selectedRates,
    required this.rateControllers,
    required this.securityDepositController,
    required this.instantBooking,
    required this.onToggleInstantBooking,
    required this.onRateTypeToggle,
  });

  @override
  Widget build(BuildContext context) {
    // TRADUCCIÓN:
    final rateTypes = {
      'day': 'Por Día',
      'week': 'Por Semana',
      'month': 'Por Mes',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          // TRADUCCIÓN:
          'Precios y Depósito',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          // TRADUCCIÓN:
          'Establece tus tarifas de alquiler y el depósito de seguridad.',
          style: TextStyle(color: Color(0xFF999999), fontSize: 14),
        ),
        const SizedBox(height: 24),

        const Text(
          // TRADUCCIÓN:
            'Tarifas de Alquiler',
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 16)
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: rateTypes.entries.map((entry) {
              final key = entry.key;
              final label = entry.value;
              final isSelected = selectedRates[key] ?? false;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) => onRateTypeToggle(key),
                      checkColor: Colors.black,
                      activeColor: const Color(0xFF0085FF),
                      side: const BorderSide(color: Colors.white70),
                    ),
                    Expanded(
                      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    if (isSelected)
                      SizedBox(
                        width: 130,
                        child: TextField(
                          controller: rateControllers[key],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            prefixText: '\$ ',
                            prefixStyle: const TextStyle(color: Color(0xFF999999), fontSize: 16),
                            hintText: '0.00',
                            hintStyle: const TextStyle(color: Color(0xFF999999)),
                            filled: true,
                            fillColor: const Color(0xFF0F0F0F),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),

        const Text(
          // TRADUCCIÓN:
            'Depósito de Seguridad',
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 16)
        ),
        const SizedBox(height: 4),
        const Text(
          // TRADUCCIÓN:
          'Esta cantidad se retiene y se devuelve después del alquiler si el artículo no sufre daños. Pon 0 si no hay depósito.',
          style: TextStyle(color: Color(0xFF999999), fontSize: 12),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: securityDepositController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            // TRADUCCIÓN:
            labelText: 'Monto del Depósito de Seguridad',
            labelStyle: TextStyle(color: Color(0xFF999999)),
            filled: true,
            fillColor: Color(0xFF1A1A1A),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            prefixText: '\$ ',
            prefixStyle: TextStyle(color: Colors.white),
          ),
        ),

        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                // TRADUCCIÓN:
                  'Habilitar Reserva Inmediata',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)
              ),
              Switch(
                value: instantBooking,
                onChanged: (_) => onToggleInstantBooking(),
                activeColor: const Color(0xFF0085FF),
              )
            ],
          ),
        ),
      ],
    );
  }
}