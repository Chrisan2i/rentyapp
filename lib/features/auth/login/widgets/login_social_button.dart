import 'package:flutter/material.dart';

class LoginSocialButton extends StatelessWidget {
  final String label;

  const LoginSocialButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
