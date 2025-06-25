// lib/features/landing/widgets/statistics_row.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class StatisticsRow extends StatelessWidget {
  const StatisticsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // Usamos spaceAround para mejor distribución
      children: const [
        _StatBox(title: '50K+', subtitle: 'Usuarios Activos'),
        _StatBox(title: '100K+', subtitle: 'Artículos'),
        _StatBox(title: '1M+', subtitle: 'Alquileres'),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StatBox({required this.title, required this.subtitle});

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