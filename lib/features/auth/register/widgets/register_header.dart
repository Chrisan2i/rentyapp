import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 60), // separa del top si hay barra de estado
            Text(
              'Join Renty',
              style: AppTextStyles.headline,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Venezuela's top rental marketplace",
              style: AppTextStyles.subtitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
