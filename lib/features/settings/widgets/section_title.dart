import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 12, left: 24),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF999999),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          letterSpacing: 0.35,
        ),
      ),
    );
  }
}
