// lib/features/add_product/widgets/step_header.dart
import 'package:flutter/material.dart';

class StepHeader extends StatelessWidget {
  final int currentStep;
  const StepHeader({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const totalSteps = 5;
    final primaryColor = const Color(0xFF0085FF);
    final inactiveColor = Colors.white.withOpacity(0.15);

    // AJUSTE DE TAMAÑO: Se redujo el padding vertical de 16 a 8
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          const Text(
            // TRADUCCIÓN: Título principal
            'Publicar un Nuevo Artículo',
            style: TextStyle(
              color: Colors.white,
              // AJUSTE DE TAMAÑO: Se redujo el tamaño de la fuente de 18 a 17
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          // AJUSTE DE TAMAÑO: Se redujo la separación de 20 a 16
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps * 2 - 1, (index) {
              if (index.isEven) {
                final stepIndex = index ~/ 2;
                bool isActive = stepIndex <= currentStep;
                return CircleAvatar(
                  // AJUSTE DE TAMAÑO: Se redujo el radio de 16 a 12
                  radius: 12,
                  backgroundColor: isActive ? primaryColor : inactiveColor,
                  child: Text(
                    '${stepIndex + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      // AJUSTE DE TAMAÑO: Se ajustó el tamaño de la fuente del número
                      fontSize: 12,
                    ),
                  ),
                );
              } else {
                final stepIndex = (index - 1) ~/ 2;
                bool isActive = stepIndex < currentStep;
                return Expanded(
                  child: Container(
                    height: 2,
                    color: isActive ? primaryColor : inactiveColor,
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}