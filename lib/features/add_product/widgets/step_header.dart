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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          const Text(
            'Post a New Item',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps * 2 - 1, (index) {
              // Even indices are circles, odd are connectors
              if (index.isEven) {
                final stepIndex = index ~/ 2;
                bool isActive = stepIndex <= currentStep;
                return CircleAvatar(
                  radius: 16,
                  backgroundColor: isActive ? primaryColor : inactiveColor,
                  child: Text(
                    '${stepIndex + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else {
                // Connector line
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