import 'package:flutter/material.dart';

class PaymentBottomBar extends StatelessWidget {
  final double totalAmount;
  final bool isLoading;
  final bool isTermsAgreed;
  final VoidCallback onPayPressed;

  const PaymentBottomBar({
    super.key,
    required this.totalAmount,
    required this.isLoading,
    required this.isTermsAgreed,
    required this.onPayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        border: Border(top: BorderSide(color: Color(0xFF222222))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                disabledBackgroundColor: Colors.grey.shade600,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: (isLoading || !isTermsAgreed) ? null : onPayPressed,
              child: isLoading
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
                  : Text(
                'Pay \$${totalAmount.toStringAsFixed(2)} and Confirm Rental',
                style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Secure payment powered by Stripe • Your card details are encrypted',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}