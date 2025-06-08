import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 12, left: 24),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.subtitle.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.35,
        ),
      ),
    );
  }
}
