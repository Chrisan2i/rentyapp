import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';

class SettingsCard extends StatelessWidget {
  final Widget child;

  const SettingsCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.white10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
