import 'package:flutter/material.dart';

class StepHeader extends StatelessWidget {
  final int currentStep;
  const StepHeader({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          const Text(
            'Post Item',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              bool isActive = index <= currentStep;
              return Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: isActive ? const Color(0xFF0085FF) : Colors.white.withOpacity(0.1),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (index < 4)
                    Container(
                      width: 40,
                      height: 4,
                      color: Colors.white.withOpacity(0.1),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
