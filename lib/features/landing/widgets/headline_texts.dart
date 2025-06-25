// lib/features/landing/widgets/headline_texts.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class HeadlineTexts extends StatelessWidget {
  const HeadlineTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Descubre, Alquila y Gana',
          style: AppTextStyles.headline,
          textAlign: TextAlign.center,
        ),
        Text(
          'Desde Cualquier Lugar de Venezuela',
          style: AppTextStyles.headlinePrimary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}