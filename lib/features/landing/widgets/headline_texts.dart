import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class HeadlineTexts extends StatelessWidget {
  const HeadlineTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Discover, Rent and Earn',
          style: AppTextStyles.headline,
          textAlign: TextAlign.center,
        ),
        Text(
          'From Anywhere in Venezuela',
          style: AppTextStyles.headlinePrimary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
