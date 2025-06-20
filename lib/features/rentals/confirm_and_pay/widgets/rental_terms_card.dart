import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RentalTermsCard extends StatelessWidget {
  final bool termsAgreed;
  final ValueChanged<bool?> onTermsChanged;

  const RentalTermsCard({
    super.key,
    required this.termsAgreed,
    required this.onTermsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rental Terms', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          _buildTermItem('Free cancellation until 24 hours before pickup'),
          _buildTermItem('Security deposit of \$200 will be held temporarily'),
          _buildTermItem('Late return fee: \$10 per hour after agreed time'),
          _buildTermItem('Damage protection included up to item value'),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(value: termsAgreed, onChanged: onTermsChanged, activeColor: Colors.blue, checkColor: Colors.black, side: const BorderSide(color: Colors.grey)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(text: 'rental terms', style: const TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline), recognizer: TapGestureRecognizer()..onTap = () {}),
                      const TextSpan(text: ' and '),
                      TextSpan(text: 'cancellation policy', style: const TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline), recognizer: TapGestureRecognizer()..onTap = () {}),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: Colors.grey.shade400)),
          Expanded(child: Text(text, style: TextStyle(color: Colors.grey.shade400))),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
      child: child,
    );
  }
}