import 'package:flutter/material.dart';

class SecurityInfoBox extends StatelessWidget {
  const SecurityInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade700),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade300),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your payment is securely held until the rental is completed. You won\'t be charged if the owner cancels.',
              style: TextStyle(color: Colors.blue.shade200, fontSize: 13),
            ),
          )
        ],
      ),
    );
  }
}