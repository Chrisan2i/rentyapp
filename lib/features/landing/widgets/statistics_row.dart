import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class StatisticsRow extends StatelessWidget {
  const StatisticsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _StatBox(title: '50K+', subtitle: 'Active Users'),
        _StatBox(title: '100K+', subtitle: 'Items Listed'),
        _StatBox(title: '1M+', subtitle: 'Rentals'),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StatBox({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: AppTextStyles.statCompactTitle),
        const SizedBox(height: 4),
        Text(subtitle, style: AppTextStyles.statCompactSubtitle),
      ],
    );
  }
}
