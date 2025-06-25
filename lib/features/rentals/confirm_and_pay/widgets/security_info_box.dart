// lib/features/rentals/views/widgets/security_info_box.dart

import 'package:flutter/material.dart';

class SecurityInfoBox extends StatelessWidget {
  const SecurityInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ✨ MEJORA: Usando el color primario del tema para adaptabilidad.
    final primaryColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ✨ MEJORA: Estilo más sutil y profesional.
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              // ✨ MEJORA: Texto en español.
              'Tu pago se retiene de forma segura hasta completar el alquiler. No se te cobrará si el propietario cancela.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.white.withOpacity(0.9)),
            ),
          )
        ],
      ),
    );
  }
}