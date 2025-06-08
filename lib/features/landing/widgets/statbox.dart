import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class StatBox extends StatelessWidget {
  final String title;
  final String subtitle;

  const StatBox({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: AppTextStyles.statTitle),
        Text(subtitle, style: AppTextStyles.statSubtitle),
      ],
    );
  }
}
